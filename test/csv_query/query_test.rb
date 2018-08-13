# frozen_string_literal: true

require_relative "../test_helper"

require "csv_query/query"
require "csv_query/outputter"

describe CsvQuery::Query do
  class CapturingOutputter
    attr_reader :lines

    def output(lines)
      @lines = lines
    end
  end

  describe "creating a new instance" do
    it "stores CSV data for later use" do
      query = CsvQuery::Query.new("foo", CsvQuery::Outputter, :bar => "baz")
      query.csv_data.must_equal("foo")
    end

    it "uses default options" do
      query = CsvQuery::Query.new("foo", CsvQuery::Outputter, :bar => "baz")
      query.options[:delimiter].must_equal(",")
    end

    it "merges options with default options" do
      query = CsvQuery::Query.new(
        "foo",
        CsvQuery::Outputter,
        :delimiter => ";",
        :select => "stuff"
      )
      query.options[:delimiter].must_equal(";")
      query.options[:select].must_equal("stuff")
    end

    it "preserves extra options" do
      query = CsvQuery::Query.new("foo", CsvQuery::Outputter, :bar => "baz")
      query.options[:bar].must_equal("baz")
    end
  end

  describe "#run" do
    it "outputs results" do
      csv_data = "Foo\nBar"
      results = [["Foo"], ["Bar"]]

      outputter = CapturingOutputter.new

      query = CsvQuery::Query.new(csv_data, outputter)
      query.run

      outputter.lines.must_equal(results)
    end

    it "filters results using :where option" do
      csv_data = "Foo\nBar\nBaz"
      results = [["Foo"], ["Baz"]]

      outputter = CapturingOutputter.new

      query = CsvQuery::Query.new(csv_data, outputter, :where => "Foo='Baz'")
      query.run

      outputter.lines.must_equal(results)
    end
  end
end
