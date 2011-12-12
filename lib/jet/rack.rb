require 'rack'
require 'guard'

module Jet
  class Rack
    def initialize
      @application = Application.new

      @application.clear_build
      @application.build_all
      @application.watch

      @file_server = ::Rack::File.new(@application.build_path)
    end

    def call(env)
      env['PATH_INFO'] = '/index.html' if env['PATH_INFO'] == '/'

      @application.wait_until_built if env['PATH_INFO'] == '/index.html'
      @file_server.call(env)
    end
  end
end
