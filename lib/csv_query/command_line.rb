require 'csv_query/query'

module CsvQuery
  class CommandLine
    def self.parse_options_from_commandline
      options = {}

      # Set defaults
      options[:delimiter] = ','
      options[:select] = '*'

      OptionParser.new do |opts|
        opts.banner = "Usage: csvq [options] [CSV file]"
        opts.separator ""
        opts.separator "Specific options:"
        opts.on(
          "-d",
          "--delimiter DELIMITER",
          "Sets the DELIMITER used between fields in the CSV data. Default: #{options[:delimiter].inspect}"
        ) do |d|
          options[:delimiter] = d
        end
        opts.on(
          "-H",
          "--headers HEADERS",
          "Comma separated list of headers. Default: First row of CSV data."
        ) do |h|
          options[:headers] = h
        end
        opts.on(
          "-q",
          "--query SQL",
          "The SQL query to run on the dataset. The table name to select data from is named \"csv\", ie \"--query 'SELECT * FROM csv'\" recreates default behavior. If specified --select and --where will be ignored."
        ) do |q|
          options[:sql_query] = q
        end
        opts.on(
          "-s",
          "--select SQL",
          "The SQL statement to select what fields to return. Unused if --query is given. Default: #{options[:select].inspect}."
        ) do |s|
          options[:select] = s
        end
        opts.on(
          "-w",
          "--where SQL",
          "The SQL conditions to use for quering the dataset. Unused if --query is given."
        ) do |w|
          options[:where] = w
        end

        opts.on_tail("-h", "--help", "Show this message.") do
          puts opts
          exit
        end
      end.parse!

      options
    end

    def self.run
      options = parse_options_from_commandline

      CsvQuery::Query.new(ARGF.read, options).run
    end
  end
end
