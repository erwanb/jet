require 'pathname'

module Jet
  class Application
    require 'jet/application/builder'
    require 'jet/application/sprockets'
    require 'jet/application/compass'
    require 'jet/application/watcher'
    require 'jet/application/paths'
    require 'jet/application/configuration'
    require 'jet/application/rack'

    include Jet::Application::Builder
    include Jet::Application::Sprockets
    include Jet::Application::Compass
    include Jet::Application::Watcher
    include Jet::Application::Paths
    include Jet::Application::Configuration
    include Jet::Application::Rack

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
  end
end
