# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "csv_query/version"

Gem::Specification.new do |s|
  s.name        = "csv_query"
  s.version     = CsvQuery::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jakob Skjerning"]
  s.email       = ["jakob@mentalized.net"]
  s.homepage    = "http://mentalized.net"
  s.summary     = %q{Use SQL to query CSV data}
  s.description = %q{CSV Query allows you to run SQL queries against data stored in CSV files.}

  s.required_ruby_version = '>= 1.9'
  s.add_dependency('sqlite3')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end
