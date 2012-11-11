require 'csv'
require 'optparse'
require 'sqlite3'

module CsvQuery
  class Query
    attr_reader :csv_data, :options

    def initialize(csv_data, options)
      @csv_data = csv_data
      @options = options
    end

    def run
      results = run_query
      output_results_table(results)
    end

    private

    def build_sql_query
      sql_query = options[:sql_query]
      return sql_query unless sql_query.nil?

      select_statement = "SELECT #{options[:select]}"
      from_statement = "FROM csv"
      where_statement = if options[:where]
        "WHERE #{options[:where]}"
      end

      [
        select_statement,
        from_statement,
        where_statement
      ].join(" ")
    end

    def create_database_and_table(csv)
      database = SQLite3::Database.new(':memory:')

      column_definitions = csv.headers.collect { |name| "\"#{name}\" VARCHAR(255)" }
      database.execute "CREATE TABLE csv (#{column_definitions.join(", ")})"

      database
    end

    def create_database_with_data_from_csv
      database = create_database_and_table(csv)
      import_csv_into_database(csv, database)
      database
    end

    def csv
      @parsed_csv ||= parse_csv_data
    end

    def database
      @database ||= create_database_with_data_from_csv
    end

    def headers
      options[:headers] || :first_row
    end

    def import_csv_into_database(csv, database)
      sql = "INSERT INTO csv VALUES (#{(['?'] * csv.headers.size).join(',')})"
      statement = database.prepare(sql)

      csv.each do |row|
        statement.execute(row.fields)
      end
    end

    def output_results_table(results)
      num_columns = if results.first
        results.first.size
      else
        0
      end
      column_widths = [0] * num_columns
      results.collect { |row|
        row.each_with_index do |column, index|
          width = column.size
          column_widths[index] = width if width > column_widths[index]
        end
      }
      format_strings = column_widths.collect { |width|
        "%#{width}s"
      }
      format_string = format_strings.join(" | ")

      results.each_with_index do |result, index|
        puts format_string % result
        if index == 0
          # Seperate headers and results
          puts column_widths.collect { |width| '-' * width }.join('-+-')
        end
      end
    end

    def parse_csv_data
      csv_options = {
        :headers => headers,
        :col_sep => options[:delimiter]
      }

      CSV.parse(csv_data, csv_options)
    end

    def run_query
      database.execute2(sql_query)
    end

    def sql_query
      @sql_query ||= build_sql_query
    end
  end
end
