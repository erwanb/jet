require 'rack'

module Jet
  class Middleware
    attr_reader :jet_app

    def initialize(app, options = {})
      @app = app
      @jet_app = Application.new(options)

      @jet_app.clear
      @jet_app.build
      @jet_app.watch

      @file_server = Rack::File.new(@jet_app.build_path)
    end

    def call(env)
      jet_app.wait_until_built
      path = env['PATH_INFO']

      if filename = file_for(path)
        if File.directory?(filename)
          index = File.join(filename, 'index.html')
          filename = File.file?(index) ? index : nil
          env['PATH_INFO'] += 'index.html'
        end

        if filename
          return @file_server.call(env)
        end
      end

      @app.call(env)
    end

    private

    def file_for(path)
      Dir[File.join(jet_app.build_path, path)].first
    end
  end
end
