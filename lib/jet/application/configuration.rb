require 'ostruct'

module Jet
  class Application
    module Configuration
      DEFAULT_CONFIG = {
        :proxy_url => 'http://localhost:3000'
      }

      def config
        @config ||= OpenStruct.new(DEFAULT_CONFIG)
      end

      def configure!
        instance_eval IO.read(root_path.join('config.rb'))
        configure_compass!
      end
    end
  end
end
