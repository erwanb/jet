require 'thor'

module Jet
  class CLI < Thor
    include Thor::Actions

    desc 'server', 'start the Jet server'
    def server
      ::Rack::Server.start(:app => Jet::Rack.new, :Port => 5000)
    end

    def self.source_root
      ::File.expand_path(::File.join(::File.dirname(__FILE__), '../../templates'))
    end

    desc 'new NAME', 'generates a new Jet app'
    attr_reader :name
    def new(name)
      @name = Utils.camelize(name)
      target = ::File.join(Dir.pwd, name)

      directory 'application', target
    end
  end
end
