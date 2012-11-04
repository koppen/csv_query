require 'csv_query/query'

module CsvQuery
  class CommandLine
    def self.run
      CsvQuery::Query.new.run
    end
  end
end
