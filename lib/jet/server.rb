require 'jet/middleware'
require 'rack/server'

module Jet
  class Server < Rack::Server
    def app
      not_found = proc { [404, { 'Content-Type' => 'text/plain' }, ['not found']] }

      Middleware.new(not_found)
    end
  end
end
