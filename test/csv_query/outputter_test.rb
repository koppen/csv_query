require_relative '../test_helper'

require 'csv_query/outputter'

describe CsvQuery::Outputter do
  describe "creating a new instance" do
    it "stores results for later access" do
      results = [["Foo"]]
      CsvQuery::Outputter.new(results).results.must_equal([["Foo"]])
    end
  end

  describe ".output" do
    it "outputs results to STDOUT" do
      output = capture_stdout do
        CsvQuery::Outputter.output([['Foo']])
      end
      output.must_equal("Foo\n---\n")
    end
  end

  describe "#output" do
    it "outputs results to STDOUT" do
      results = [
        ["Foo", "Bar"],
        ["Baz", "Qux"]
      ]

      output = capture_stdout do
        CsvQuery::Outputter.output(results)
      end

      output.must_equal <<EOS
Foo | Bar
----+----
Baz | Qux
EOS
    end

    it "adapts column widths to result widths" do
      results = [
        ["A", "B", "Somewhat long header"],
        ["1", "Somewhat long result", "3"]
      ]

      output = capture_stdout do
        CsvQuery::Outputter.output(results)
      end

      output.must_equal <<EOS
A |                    B | Somewhat long header
--+----------------------+---------------------
1 | Somewhat long result |                    3
EOS
    end

    it "works with numeric results" do
      results = [
        ["Animal", "COUNT(*)", "Average"],
        ["Monkeys", 12, 123.456]
      ]

      output = capture_stdout do
        CsvQuery::Outputter.output(results)
      end

      output.must_equal <<EOS
 Animal | COUNT(*) | Average
--------+----------+--------
Monkeys |       12 | 123.456
EOS
    end
  end

  it "outputs nothing if results are empty" do
    output = capture_stdout do
      CsvQuery::Outputter.output([])
    end
    output.must_equal ""
  end
end
