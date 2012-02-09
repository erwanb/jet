module Jet
  class Application
    module Builder
      def clear
        FileUtils.rm_rf(Dir[build_path.join('*')])
      end

      def build
        build_asset(:javascript)
        build_asset(:stylesheet)
        copy_static_assets_to_build
      end

      def build_asset(name)
        path = build_path.join(ASSETS[name])

        asset(name).write_to(path)
      rescue Exception => exception
        File.open(path, "w") do |file|
          file.write("#{exception.class.name}\n\n#{exception.message}")
        end
      end

      def copy_static_asset_to_build(file)
        absolute_path = root_path.join(file)
        build_relative_path = build_path.join(absolute_path.relative_path_from(static_path))

        FileUtils.mkdir_p(build_relative_path.dirname) unless build_relative_path.dirname.exist?
        FileUtils.cp(root_path.join(file), build_relative_path)
      end

      def delete_static_asset_from_build(file)
        absolute_path       = root_path.join(file)
        build_relative_path = build_path.join(absolute_path.relative_path_from(static_path))

        FileUtils.rm_rf(build_relative_path)
      end

      def copy_static_assets_to_build
        FileUtils.cp_r(File.join(static_path, '.'), build_path)
      end
    end
  end
end
