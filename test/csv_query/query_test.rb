require 'minitest/autorun'

# Require files from the project lib-directory
$:.unshift(File.join(File.dirname(__FILE__), "..", "..", "lib"))
require 'csv_query/query'

describe CsvQuery::Query do

  before do
    @csv_data = "Foo,Bar\nBaz,Qux"
  end

  describe "creating a new instance" do
    it "stores CSV data for later use" do
      query = CsvQuery::Query.new('foo', {:bar => 'baz'})
      query.csv_data.must_equal('foo')
    end

    it "merges options with default options" do
      query = CsvQuery::Query.new('foo')
      query.options[:delimiter].must_equal(',')
      query.options[:select].must_equal('*')
    end

    it "preserves extra options" do
      query = CsvQuery::Query.new('foo', {:bar => 'baz'})
      query.options[:bar].must_equal('baz')
    end
  end

  describe "#run" do
    it "outputs results" do
      existing_stream = $stdout
      $stdout = StringIO.new
      query = CsvQuery::Query.new(@csv_data)
      query.run
      output = $stdout.string
      $stdout = existing_stream

      output.must_equal <<EOS
Foo | Bar
----+----
Baz | Qux
EOS
    end
  end

end
