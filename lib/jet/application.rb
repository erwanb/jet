require 'pathname'

module Jet
  class Application
    require 'jet/application/builder'
    require 'jet/application/sprockets'
    require 'jet/application/compass'

    include Jet::Application::Builder
    include Jet::Application::Sprockets
    include Jet::Application::Compass

    attr_reader :environment
    attr_reader :root_path
    attr_reader :build_path

    DEFAULT_OPTIONS = {
      :environment => :development,
      :root_path   => Dir.pwd
    }

    def initialize(options = {})
      options = DEFAULT_OPTIONS.merge(options)

      @environment = options[:environment]
      @root_path   = Pathname.new(options[:root_path])
      @build_path  = root_path.join('build', environment.to_s)

      # Compass needs current dir to be project path
      Dir.chdir(@root_path)

      configure_compass
    end

    def public_path
      @public_path ||= root_path.join('public')
    end
  end
end
