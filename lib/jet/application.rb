require 'coffee_script'
require 'sprockets-sass'
require 'compass'
require 'pathname'

module Jet
  class Application
    ASSET_PATHS = ['config', 'app/models', 'app/controllers', 'app/views',
      'app/templates', 'app/states', 'app/stylesheets', 'lib', 'vendor']

    def initialize(environment = :development)
      @environment = environment
      @root_path   = Dir.pwd
      @build_path  = ::File.join(@root_path, 'build', @environment.to_s)

      Compass.configuration do |config|
        config.project_path    = @root_path
        config.images_dir      = ::File.join('build', 'development')
        config.images_path     = 'app'
        config.http_images_dir = '/'
      end
    end

    def clear_build
      FileUtils.rm_rf(Dir[::File.join(@build_path, '*')])
    end

    def build_all
      build_javascript
      build_stylesheet
      copy_static_assets_to_build
    end

    def build_javascript
      application_javascript_asset.write_to(::File.join(@build_path, 'application.js'))
    end

    def build_stylesheet
      application_stylesheet_asset.write_to(::File.join(@build_path, 'application.css'))
    end

    def copy_to_build(file)
      absolute_path = Pathname.new(::File.dirname(file))
      build_relative_path = Pathname.new(::File.join(@build_path, absolute_path.relative_path_from(Pathname.new('public'))))

      FileUtils.mkdir_p(build_relative_path) unless build_relative_path.exist?
      FileUtils.cp(file, build_relative_path)
    end

    private

    def copy_static_assets_to_build
      FileUtils.cp_r(::File.join(@root_path, 'public', '.'), @build_path)
    end

    def application_javascript_asset
      sprockets_environment.find_asset('boot.js')
    end

    def application_stylesheet_asset
      sprockets_environment.find_asset('application.css')
    end

    def sprockets_environment
      return @sprockets_environment if defined? @sprockets_environment

      @sprockets_environment = Sprockets::Environment.new
      ASSET_PATHS.each do |asset_path|
        @sprockets_environment.append_path(::File.join(@root_path, asset_path))
      end
      @sprockets_environment
    end
  end
end
