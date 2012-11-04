require 'csv'
require 'optparse'
require 'sqlite3'

module CsvQuery
  class Query
    def create_database_and_table(csv)
      database = SQLite3::Database.new(':memory:')

      column_definitions = csv.headers.collect { |name| "#{name} VARCHAR(255)" }
      database.execute "CREATE TABLE csv (#{column_definitions.join(", ")})"

      database
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

    def parse_csv_data(options)
      csv_options = {
        :headers => true,
        :col_sep => options[:delimiter] || ','
      }

      csv_data = if options[:csv_file]
        File.read(options[:csv_file])
      else
        csv_data = STDIN.read
      end
      csv = CSV.parse(csv_data, csv_options)
    end

    def run(options)
      csv = parse_csv_data(options)

      database = create_database_and_table(csv)
      import_csv_into_database(csv, database)

      results = database.execute2(options[:sql_query])
      output_results_table(results)
    end
  end
end
