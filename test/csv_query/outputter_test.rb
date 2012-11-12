require 'minitest/autorun'
require 'stringio'

# Require files from the project lib-directory
$:.unshift(File.join(File.dirname(__FILE__), "..", "..", "lib"))
require 'csv_query/outputter'

describe CsvQuery::Outputter do
  def outputter(results = [])
    @outputter ||= CsvQuery::Outputter.new(results)
  end

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
        outputter(results).output
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

      existing_stream = $stdout
      $stdout = StringIO.new
      output = capture_stdout do
        outputter(results).output
      end

      output.must_equal <<EOS
A |                    B | Somewhat long header
--+----------------------+---------------------
1 | Somewhat long result |                    3
EOS
      end
  end

  def capture_stdout
    existing_stream = $stdout
    $stdout = StringIO.new
    yield
    output = $stdout.string
    $stdout = existing_stream
    return output
  end

end
