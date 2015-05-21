require 'sqlite3'

module CsvQuery
  class Table < Struct.new(:database, :csv, :table_name)
    class EmptyCsvHeadersError < RuntimeError; end

    def sqlite_database
      database.sqlite_database
    end

    def column_names
      @csv_headers ||= csv.headers
    end

    def import_data_from_csv
      insert_statement = sqlite_database.prepare(build_insert_sql)

      sqlite_database.transaction do
        csv.each do |row|
          insert_statement.execute(row.fields)
        end
      end
    end

    def build_insert_sql
      "INSERT INTO #{table_name} VALUES (#{(['?'] * column_names.size).join(',')})"
    end

    def create_table
      if csv.empty?
        # Ruby's CSV lib seems to ignore headers if there are no data rows
        raise EmptyCsvHeadersError, "the CSV has no detected headers - needs at least one row to load headers"
      end

      column_definitions = column_names.collect { |name| "\"#{name}\" TEXT" }
      sqlite_database.execute "CREATE TABLE #{table_name} (#{column_definitions.join(", ")})"
    end

  end

end
