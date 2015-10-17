require_relative "../test_helper"

require "csv_query/database"

describe CsvQuery::Database do
  def csv_data
    @csv_data ||= CSV.parse("Bar", :headers => ["Foo"])
  end

  def build_database
    CsvQuery::Database.new(csv_data)
  end

  describe ".new" do
    it "creates SQLite database" do
      database = build_database
      database.database.class.must_equal(SQLite3::Database)
    end

    it "creates a database table" do
      database = build_database

      columns = database.database.table_info("csv")
      columns.collect { |column| column["name"] }.must_equal(["Foo"])
    end
  end

  describe "#import_csv" do
    it "imports data from csv" do
      database = build_database
      database.import_data_from_csv(csv_data)

      results = database.database.query("SELECT * FROM csv")
      results.to_a.must_equal([["Bar"]])
    end
  end

  describe "#query" do
    it "returns headers and results as arrays" do
      database = build_database
      database.import_data_from_csv(csv_data)

      results = database.query("SELECT * FROM csv")
      results.to_a.must_equal([["Foo"], ["Bar"]])
    end
  end
end
