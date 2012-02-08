module Jet
  class InstallGenerator < Rails::Generators::Base

    desc "Install Jet in this Rails app"

    def disable_asset_pipeline_railtie
      say_status :config, "Updating configuration to remove asset pipeline"
      gsub_file app, "require 'rails/all'", <<-RUBY.strip_heredoc
        # Pick the frameworks you want:
        require "active_record/railtie"
        require "action_controller/railtie"
        require "action_mailer/railtie"
        require "active_resource/railtie"
        require "rails/test_unit/railtie"
      RUBY
    end

    # TODO: Support sprockets API
    def disable_asset_pipeline_config
      regex = /^\n?\s*#.*\n\s*(#\s*)?config\.assets.*\n/
      gsub_file app, regex, ''
      gsub_file Rails.root.join("config/environments/development.rb"), regex, ''
      gsub_file Rails.root.join("config/environments/production.rb"), regex, ''
    end

    def remove_assets_group
      regex = /^\n(#.*\n)+group :assets.*\n(.*\n)*?end\n/

      gsub_file "Gemfile", regex, ''
    end

    def enable_assets_in_development
      gsub_file "config/environments/development.rb", /^end/, "\n  config.jet_enabled = true\nend"
    end

    private

    def app
      @app ||= Rails.root.join("config/application.rb")
    end
  end
end
