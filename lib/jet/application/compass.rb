require 'compass'

module Jet
  class Application
    module Compass
      private

      # Every images in app/images will be concatenated into a sprite by compass.
      # It doesn't make sense to set images_path to 'app' but compass needs a
      # directory inside the image directory to name the sprite, so this is is a
      # necessary hack for now.
      # For more info see : http://compass-style.org/help/tutorials/spriting
      def configure_compass
        ::Compass.configuration do |config|
          config.project_path    = root_path
          config.images_dir      = build_path.relative_path_from(root_path).to_s
          config.images_path     = 'app'
          config.http_images_dir = '/'
          config.sass_options    = {:cache_location => tmp_path.join('sass-cache')}

          config.on_sprite_generated do |sprite_data|
            FileUtils.rm(Dir[build_path.join('images-*.png')])
          end
        end
      end
    end
  end
end
