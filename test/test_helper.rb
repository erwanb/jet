require 'simplecov'

SimpleCov.start if ENV["COVERAGE"]

gem "minitest"

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
require 'mocha'

require 'jet'
