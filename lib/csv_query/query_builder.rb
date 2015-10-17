module CsvQuery
  class QueryBuilder
    DEFAULT_OPTIONS = {
      :select => "*"
    }

    attr_reader :options

    def initialize(options)
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def call
      build_sql_query
    end

    private

    def build_sql_query
      [
        select_statement,
        from_statement,
        where_statement
      ].join(" ").strip
    end

    def from_statement
      "FROM csv"
    end

    def select_statement
      "SELECT #{options[:select]}"
    end

    def where_statement
      return nil unless options[:where]
      "WHERE #{options[:where]}"
    end
  end
end
