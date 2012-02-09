require 'coffee_script'
require 'sprockets-sass'
require 'jet/sprockets/cache/file_store'

module Jet
  class Application
    module Sprockets
      ASSETS_PATHS = [
        'app/models',
        'app/controllers',
        'app/views',
        'app/templates',
        'app/stylesheets',
        'app',
        'lib',
        'vendor'
      ]

      def asset(name)
        sprockets_environment.find_asset(ASSETS[name])
      end

      def sprockets_environment
        return @sprockets_environment if defined? @sprockets_environment

        @sprockets_environment = ::Sprockets::Environment.new
        @sprockets_environment.cache = Jet::Sprockets::Cache::FileStore.new(tmp_path)

        ASSETS_PATHS.each do |asset_path|
          @sprockets_environment.append_path(root_path.join(asset_path))
        end
        @sprockets_environment
      end
    end
  end
end
