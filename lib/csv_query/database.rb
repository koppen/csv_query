require 'sqlite3'
require 'csv_query/table'

module CsvQuery
  # Wraps a SQLite in-memory database with a single table named csv by default if you pass in only a csv to initialize.
  # Don't pass in a CSV and use #create_table and #import_data_from_csv to to perform more complex multi-table loads.
  class Database
    attr_accessor :sqlite_database
    alias_method :database, :sqlite_database # TODO: Can be removed by repo maintainer at version upgrade?

    def initialize(default_csv_to_create_table_for=nil)
      @tables = []
      @sqlite_database = SQLite3::Database.new(':memory:')

      create_table(default_csv_to_create_table_for, 'csv') if !default_csv_to_create_table_for.nil?
    end

    def create_table(csv, table_name)
      CsvQuery::Table.new(self, csv, table_name).create_table
    end

    def import_data_from_csv(csv, table_name='csv')
      CsvQuery::Table.new(self, csv, table_name).import_data_from_csv
    end

    def load_csv(csv, table_name)
      table = CsvQuery::Table.new(self, csv, table_name)
      table.create_table
      table.import_data_from_csv
    end

    # Returns the results of sql. First row of the resultset contains the column names
    def query(sql)
      @sqlite_database.execute2(sql)
    end

    def query_hashes(sql)
      old_value = @sqlite_database.results_as_hash
      begin
        @sqlite_database.results_as_hash = true
        hashes = @sqlite_database.execute(sql)

        cleanup_sqlite_hashes!(hashes)

        hashes
      ensure
        @sqlite_database.results_as_hash = old_value
      end
    end

    protected

    # Not sure why, but in addition to column names, you also get integer indexes as keys... prefer only string
    # keys that are the column names.
    def cleanup_sqlite_hashes!(hashes)
      hashes.each do |h|
        integer_keys = h.keys.select{|k| k.is_a? Numeric }
        integer_keys.each{|k| h.delete(k)}
      end
    end
  end
end
