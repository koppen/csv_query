require_relative "../test_helper"

require "csv_query/query_builder"

describe CsvQuery::QueryBuilder do
  def described_class
    CsvQuery::QueryBuilder
  end

  describe "creating a new instance" do
    it "stores options later use" do
      query_builder = described_class.new(:foo => "bar")
      query_builder.options.must_equal(:select => "*", :foo => "bar")
    end

    it "uses default options" do
      query_builder = described_class.new(:foo => "bar")
      query_builder.options[:select].must_equal("*")
    end

    it "merges options with default options" do
      query = described_class.new(:where => "stuff")
      query.options[:select].must_equal("*")
      query.options[:where].must_equal("stuff")
    end
  end

  describe "#call" do
    it "returns a string with an SQL query" do
      query_builder = CsvQuery::QueryBuilder.new({})
      result = query_builder.call
      result.must_equal("SELECT * FROM csv")
    end
  end
end
