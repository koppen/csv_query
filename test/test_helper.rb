require 'minitest/autorun'
require 'stringio'

# Require files from the project lib-directory
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

def capture_stdout
  existing_stream = $stdout
  $stdout = StringIO.new
  yield
  output = $stdout.string
  $stdout = existing_stream
  return output
end
