require 'csv_query/query'

module CsvQuery
  class CommandLine
    def self.parse_options_from_commandline
      options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: csvq [options] [SQL query] [CSV file]"

        opts.on(
          "-d",
          "--delimiter DELIMITER",
          "Sets the DELIMITER used between fields in the CSV data"
        ) do |d|
          options[:delimiter] = d
        end
      end.parse!

      options[:sql_query] = ARGV[0]
      options[:csv_file] = ARGV[1]

      options
    end

    def self.run
      options = parse_options_from_commandline

      CsvQuery::Query.new.run(options)
    end
  end
end
