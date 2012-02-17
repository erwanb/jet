require 'jet/middleware'
require 'rack/reverse_proxy'

module Jet
  class Application
    module Rack
      def call(env)
        middleware.call(env)
      end

      def middleware
        return @middleware if defined? @middleware

        proxy_url = config.proxy_url

        proxy = Rack::ReverseProxy.new do
          reverse_proxy '*', proxy_url
        end

        @middleware = Middleware.new(proxy, self)
      end
    end
  end
end
