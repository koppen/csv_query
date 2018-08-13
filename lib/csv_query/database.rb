# frozen_string_literal: true

require "sqlite3"

module CsvQuery
  # Wraps a SQLite in-memory database with a single table named csv.
  class Database
    attr_reader :database

    def initialize(csv)
      @database = SQLite3::Database.new(":memory:")
      @columns = csv.headers
      create_table(@columns)
    end

    def import_data_from_csv(csv)
      columns = csv.headers

      sql = "INSERT INTO csv VALUES (#{(['?'] * columns.size).join(',')})"
      statement = database.prepare(sql)

      csv.each do |row|
        statement.execute(row.fields)
      end
    end

    # Returns the results of sql. First row of the resultset contains the column
    # names
    def query(sql)
      database.execute2(sql)
    end

    private

    def create_table(column_names)
      column_definitions = column_names.collect do |name|
        "\"#{name}\" VARCHAR(255)"
      end
      database.execute "CREATE TABLE csv (#{column_definitions.join(', ')})"
    end
  end
end
