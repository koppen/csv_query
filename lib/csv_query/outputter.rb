# frozen_string_literal: true

module CsvQuery
  class Outputter
    attr_reader :results

    def self.output(results)
      new(results).output
    end

    def initialize(results)
      @results = results
    end

    def output
      results.each_with_index do |result, index|
        puts format_string % result
        if index.zero?
          puts separator_line
        end
      end
    end

    private

    def column_widths
      results.each_with_object([0] * number_of_columns) { |row, column_widths|
        row.each_with_index do |value, index|
          width = value.to_s.size
          column_widths[index] = width if width > column_widths[index]
        end
      }
    end

    def format_string
      return @format_string if @format_string

      format_strings = column_widths.collect { |width|
        "%#{width}s"
      }
      @format_string = format_strings.join(" | ")
    end

    def number_of_columns
      if results.first
        results.first.size
      else
        0
      end
    end

    def separator_line
      column_widths.collect { |width| "-" * width }.join("-+-")
    end
  end
end
