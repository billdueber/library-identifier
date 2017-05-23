$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'library/identifier'

require 'minitest/autorun'
require 'minitest/reporters'

# Make sure tests run under RubyMine (as evidenced by RM_INFO)
if ENV['RM_INFO'] =~ /\S/
  MiniTest::Reporters.use!
else
  filter = Minitest::ExtensibleBacktraceFilter.default_filter
  reporter = Minitest::Reporters::SpecReporter.new(color: true, filter: filter)
  Minitest::Reporters.use! reporter
end
