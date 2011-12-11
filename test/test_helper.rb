require 'simplecov'

SimpleCov.start if ENV["COVERAGE"]

gem "minitest"

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha'

require 'jet'

def fixtures_path
  Pathname.new(File.dirname(__FILE__)).join('fixtures')
end
