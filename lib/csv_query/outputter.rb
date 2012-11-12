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
        if index == 0
          puts separator_line
        end
      end
    end

    private

    def column_widths
      return @column_widths if @column_widths
      num_columns = if results.first
        results.first.size
      else
        0
      end

      column_widths = [0] * num_columns
      results.collect { |row|
        row.each_with_index do |value, index|
          width = value.to_s.size
          column_widths[index] = width if width > column_widths[index]
        end
      }
      return column_widths
    end

    def format_string
      return @format_string if @format_string

      format_strings = column_widths.collect { |width|
        "%#{width}s"
      }
      @format_string = format_strings.join(" | ")
    end

    def separator_line
      column_widths.collect { |width| '-' * width }.join('-+-')
    end
  end
end
