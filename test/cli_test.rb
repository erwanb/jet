require 'test_helper'

describe Jet::CLI do
  describe '#server' do
    Foreman::CLI.any_instance.expects(:start)
    Jet::CLI.new.server
  end
end
