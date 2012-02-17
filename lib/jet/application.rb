require 'pathname'

module Jet
  class Application
    require 'jet/application/builder'
    require 'jet/application/sprockets'
    require 'jet/application/compass'
    require 'jet/application/watcher'
    require 'jet/application/paths'
    require 'jet/application/configuration'

    include Jet::Application::Builder
    include Jet::Application::Sprockets
    include Jet::Application::Compass
    include Jet::Application::Watcher
    include Jet::Application::Paths
    include Jet::Application::Configuration

    ASSETS = {
      :javascript => 'application.js',
      :stylesheet => 'application.css'
    }

    attr_reader :environment

    def initialize(options = {})
      @environment = options.fetch(:environment, :development)
      @root_path   = Pathname.new(options.fetch(:root_path, Dir.pwd))

      configure!
    end

    def call(env)
      middleware.call(env)
    end

    def middleware
      require 'rack/reverse_proxy'
      require 'jet/middleware'
      return @middleware if defined? @middleware

      proxy_url = config.proxy_url

      proxy = Rack::ReverseProxy.new do
        reverse_proxy '*', proxy_url
      end

      @middleware = Middleware.new(proxy, self)
    end
  end
end
