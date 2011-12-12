require 'test_helper'

describe Jet::CLI do
  before do
    @cli = Jet::CLI.new
  end

  describe '#server' do
  end

  describe '#new' do
    it 'camelizes app name' do
      Jet::Utils.expects(:camelize).with('new_app').returns('camelized_name')
      @cli.stubs(:directory)
      @cli.new('new_app')
      @cli.name.must_equal('camelized_name')
    end

    it 'generates app skeleton in current dir' do
      @cli.expects(:directory).with('application', File.join(Dir.pwd, 'new_app'))
      @cli.new('new_app')
    end
  end
end
