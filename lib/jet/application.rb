module Jet
  class Application
    require 'jet/application/builder'
    require 'jet/application/sprockets'
    require 'jet/application/compass'

    include Jet::Application::Builder
    include Jet::Application::Sprockets
    include Jet::Application::Compass

    attr_reader :environment

    def initialize(environment = :development)
      @environment = environment
      @root_path   = Dir.pwd
      @build_path  = ::File.join(@root_path, 'build', @environment.to_s)

      configure_compass
    end
  end
end
