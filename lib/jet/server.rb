require 'jet/middleware'
require 'rack/reverse_proxy'
require 'rack/server'

module Jet
  class Server < Rack::Server
    def app
      jet_app = Jet::Application.new

      proxy = Rack::ReverseProxy.new do
        reverse_proxy '*', jet_app.config.proxy_url
      end

      Middleware.new(proxy, jet_app)
    end
  end
end
