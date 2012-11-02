#!/usr/bin/env ruby

# Usage
# csvq [options] sql csv
#
# Options
# -d: column_delimiter

# puts ARGV.inspect

require 'optparse'
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on(
    "-d",
    "--delimiter DELIMITER",
    "Sets the DELIMITER used between fields in the CSV data"
  ) do |d|
    options[:delimiter] = d
  end
end.parse!

sql_query = ARGV[0]

require 'csv'
csv_options = {
  :headers => true,
  :col_sep => options[:delimiter] || ','
}

csv_data = STDIN.read
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

database.execute2(sql_query).each do |result|
  puts result.join(' | ')
end
