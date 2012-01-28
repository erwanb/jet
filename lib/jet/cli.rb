require 'thor'

module Jet
  class CLI < Thor
    include Thor::Actions

    desc 'server', 'start the Jet server (short-cut alias: "s")'
    def server
      ::Rack::Server.start(:config => 'config.ru', :Port => 5000)
    end
    map 's' => 'server'

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

    desc 'generate_prototype NAME', 'generates a new prototype (short-cut alias: "gp")'
    def generate_prototype(name)
      # name = Utils.underscore(name)
      target = ::File.join(Dir.pwd, 'test/prototypes', name)

      directory 'prototype', target
    end
    map 'gp' => 'generate_prototype'
  end
end
