require 'coffee_script'
require 'sprockets-sass'

module Jet
  class Application
    module Sprockets
      ASSETS_PATHS = [
        'config',
        'app/models',
        'app/controllers',
        'app/views',
        'app/templates',
        'app/states',
        'app/stylesheets',
        'lib',
        'vendor'
      ]

      private

      def application_javascript_asset
        sprockets_environment.find_asset('boot.js')
      end

      def application_stylesheet_asset
        sprockets_environment.find_asset('application.css')
      end

      def sprockets_environment
        return @sprockets_environment if defined? @sprockets_environment

        @sprockets_environment = Sprockets::Environment.new
        ASSETS_PATHS.each do |asset_path|
          @sprockets_environment.append_path(::File.join(@root_path, asset_path))
        end
        @sprockets_environment
      end
    end
  end
end
