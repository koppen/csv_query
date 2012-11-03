#!/usr/bin/env ruby

require 'optparse'
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

sql_query = ARGV[0]
csv_file = ARGV[1]

require 'csv'
csv_options = {
  :headers => true,
  :col_sep => options[:delimiter] || ','
}

csv_data = if csv_file
  File.read(csv_file)
else
  csv_data = STDIN.read
end
csv = CSV.parse(csv_data, csv_options)
# puts csv.headers.inspect

require 'sqlite3'

# puts "Creating database"
database = SQLite3::Database.new(':memory:')

# puts "Creating table"
column_definitions = csv.headers.collect { |name| "#{name} VARCHAR(255)" }
database.execute "CREATE TABLE csv (#{column_definitions.join(", ")})"

# puts "Importing"
sql = "INSERT INTO csv VALUES (#{(['?'] * csv.headers.size).join(',')})"
statement = database.prepare(sql)

csv.each do |row|
  statement.execute(row.fields)
end

results = database.execute2(sql_query)

num_columns = if results.first
  results.first.size
else
  0
end
column_widths = [0] * num_columns
results.collect { |row|
  row.each_with_index do |column, index|
    width = column.size
    column_widths[index] = width if width > column_widths[index]
  end
}
format_strings = column_widths.collect { |width|
  "%#{width}s"
}
format_string = format_strings.join(" | ")

results.each_with_index do |result, index|
  puts format_string % result
  if index == 0
    # Seperate headers and results
    puts column_widths.collect { |width| '-' * width }.join('-+-')
  end
end
