# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "csv_query/version"

Gem::Specification.new do |s|
  s.name        = "csv_query"
  s.version     = CsvQuery::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jakob Skjerning"]
  s.email       = ["jakob@mentalized.net"]
  s.homepage    = "http://mentalized.net"
  s.summary     = "Use SQL to query CSV data"
  s.description = "CSV Query allows you to run SQL queries against data " \
                  "stored in CSV files."

  s.required_ruby_version = ">= 2.3"
  s.add_dependency("sqlite3")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map do |f|
    File.basename(f)
  end
  s.require_paths = ["lib"]
end
