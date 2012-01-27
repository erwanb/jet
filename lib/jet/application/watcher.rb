require 'guard'

module Jet
  class Application
    module Watcher
      def watch
        @mutex = Mutex.new

        Thread.new do
          listener = Guard::Listener.select_and_init(:watchdir => root_path, :watch_all_modifications => true)

          listener.on_change do |files|
            files = files.select { |file| file =~ /^!?(app|config|static|lib|vendor|test\/prototypes)\/.+$/ }

            @mutex.synchronize { run_on_change(files) } unless files.empty?
          end
          listener.start
        end
      end

      def run_on_change(paths)
        already_built_javascript = false
        already_built_stylesheet = false

        paths.each do |path|
          if File.is_static?(path)
            File.is_deleted?(path) ? delete_from_build(path[1..-1]) : copy_to_build(path)
          elsif File.is_prototype?(path)
            File.is_deleted?(path) ? delete_prototype_asset_from_build(path[1..-1]) : copy_prototype_asset_to_build(path)
          elsif File.is_javascript?(path) && !already_built_javascript
            build_javascript
            already_built_javascript = true
          elsif File.is_stylesheet?(path) && !already_built_stylesheet
            build_stylesheet
            already_built_stylesheet = true
          end
        end
      end

      def wait_until_built
        @mutex.synchronize {}
      end
    end
  end
end
