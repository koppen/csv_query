#!/usr/bin/env ruby

# Usage
# csvq [options] sql csv
#
# Options
# -d: column_delimiter

# puts ARGV.inspect

sql_query = ARGV[0]

require 'csv'
csv_data = STDIN.read
csv = CSV.parse(csv_data, :headers => true)
# puts csv.headers.inspect

require 'sqlite3'

begin
  database_path = 'tmpdb.sqlite3'
  database = SQLite3::Database.new(database_path)

  column_definitions = csv.headers.collect { |name| "#{name} VARCHAR(255)" }
  # puts column_definitions

  database.execute "CREATE TABLE csv (#{column_definitions.join(", ")})"

  csv.each do |row|
    sql = "INSERT INTO csv VALUES (#{(['?'] * row.fields.size).join(',')})"
    database.execute(sql, row.fields)
  end

  puts sql_query
  database.execute(sql_query).each do |result|
    puts result.join(' | ')
  end

rescue Exception => error
  raise
ensure
  File.delete(database_path)
end
