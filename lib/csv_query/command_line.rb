require 'csv_query/query'

module CsvQuery
  class CommandLine
    def self.parse_options_from_commandline
      options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: csvq [options] [CSV file]"

        opts.on(
          "-d",
          "--delimiter DELIMITER",
          "Sets the DELIMITER used between fields in the CSV data"
        ) do |d|
          options[:delimiter] = d
        end
        opts.on(
          "-q",
          "--query SQL",
          "The SQL query to run on the dataset."
        ) do |q|
          options[:sql_query] = q
        end
      end.parse!

      options[:csv_file] = ARGV[0]

      options
    end

    def self.run
      options = parse_options_from_commandline

      CsvQuery::Query.new(options).run
    end
  end
end
