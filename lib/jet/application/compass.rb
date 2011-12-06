require 'compass'

module Jet
  class Application
    module Compass
      private

      def configure_compass
        Compass.configuration do |config|
          config.project_path    = @root_path
          config.images_dir      = ::File.join('build', 'development')
          config.images_path     = 'app'
          config.http_images_dir = '/'
        end
      end
    end
  end
end
