require 'pathname'

module Jet
  class Application
    module Builder
      def clear_build
        FileUtils.rm_rf(Dir[::File.join(build_path, '*')])
      end

      def build_all
        build_javascript
        build_stylesheet
        copy_static_assets_to_build
      end

      def build_javascript
        application_javascript_asset.write_to(::File.join(build_path, 'application.js'))
      end

      def build_stylesheet
        application_stylesheet_asset.write_to(::File.join(build_path, 'application.css'))
      end

      def copy_to_build(file)
        absolute_path = Pathname.new(::File.dirname(file))
        build_relative_path = Pathname.new(::File.join(build_path, absolute_path.relative_path_from(Pathname.new('public'))))

        FileUtils.mkdir_p(build_relative_path) unless build_relative_path.exist?
        FileUtils.cp(::File.join(root_path, file), build_relative_path)
      end

      def copy_static_assets_to_build
        FileUtils.cp_r(::File.join(root_path, 'public', '.'), build_path)
      end
    end
  end
end
