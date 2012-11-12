require_relative '../test_helper'

require 'csv_query/query'
require 'csv_query/outputter'

describe CsvQuery::Query do

  describe "creating a new instance" do
    it "stores CSV data for later use" do
      query = CsvQuery::Query.new('foo', CsvQuery::Outputter, {:bar => 'baz'})
      query.csv_data.must_equal('foo')
    end

    it "merges options with default options" do
      query = CsvQuery::Query.new('foo', CsvQuery::Outputter, {:bar => 'baz'})
      query.options[:delimiter].must_equal(',')
      query.options[:select].must_equal('*')
    end

    it "preserves extra options" do
      query = CsvQuery::Query.new('foo', CsvQuery::Outputter, {:bar => 'baz'})
      query.options[:bar].must_equal('baz')
    end
  end

  describe "#run" do
    it "outputs results" do
      csv_data = "Foo\nBar"
      results = [["Foo"], ["Bar"]]

      outputter = MiniTest::Mock.new
      outputter.expect(:output, '', [results])

      query = CsvQuery::Query.new(csv_data, outputter)
      query.run

      outputter.verify
    end
  end

end
