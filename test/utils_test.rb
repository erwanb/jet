require 'test_helper'

describe Jet::Utils do
  # Taken from rails
  # See : https://github.com/rails/rails/blob/master/actionpack/test/template/javascript_helper_test.rb
  describe "#escape_javascript" do
    it 'return a string suitable for use in javascript' do
      Jet::Utils.escape_javascript(%(This "thing" is really\n netos')).must_equal(%(This \\"thing\\" is really\\n netos\\'))
      Jet::Utils.escape_javascript(%(dont </close> tags)).must_equal(%(dont <\\/close> tags))
      Jet::Utils.escape_javascript(%(backslash\\test)).must_equal(%(backslash\\\\test))
    end
  end
end
