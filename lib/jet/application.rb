require 'pathname'

module Jet
  class Application
    require 'jet/application/builder'
    require 'jet/application/sprockets'
    require 'jet/application/compass'
    require 'jet/application/paths'

    include Jet::Application::Builder
    include Jet::Application::Sprockets
    include Jet::Application::Compass
    include Jet::Application::Paths

    attr_reader :environment

    def initialize(options = {})
      @environment = options.fetch(:environment, :development)
      @root_path   = Pathname.new(options.fetch(:root_path, Dir.pwd))

      # Compass needs current dir to be project path
      Dir.chdir(root_path)

      configure_compass
    end
  end
end
