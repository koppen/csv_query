# frozen_string_literal: true

require "coveralls"
Coveralls.wear!

require "minitest/autorun"
require "stringio"

# Require files from the project lib-directory
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

def capture_stdout
  existing_stream = $stdout
  $stdout = StringIO.new
  yield
  output = $stdout.string
  $stdout = existing_stream
  output
end
