require 'thor'
require 'foreman'
require 'foreman/cli'

module Jet
  class CLI < Thor
    include Thor::Actions

    desc 'server', 'start the Jet server'
    def server
      Foreman::CLI.new.start
    end

    def self.source_root
      ::File.expand_path(::File.join(::File.dirname(__FILE__), 'templates'))
    end

    desc 'new NAME', 'generates a new Jet app'
    attr_reader :name
    def new(name)
      @name = name
      target = ::File.join(Dir.pwd, name)

      directory 'application', target
    end
  end
end
