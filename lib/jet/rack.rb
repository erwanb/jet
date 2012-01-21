require 'rack'

module Jet
  class Rack
    attr_reader :application

    def initialize
      @application = Application.new

      @application.clear_build
      @application.build_all
      @application.watch

      @file_server = ::Rack::Directory.new(@application.build_path)
    end

    def call(env)
      @application.wait_until_built if env['PATH_INFO'] == '/index.html'
      @file_server.call(env)
    end
  end
end
