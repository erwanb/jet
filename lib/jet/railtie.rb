require "jet/middleware"

module Jet
  # Use Jet inside of Rails 3.x. To use, simply add
  # Jet to your +Gemfile+:
  #
  #   !!!ruby
  #   gem 'jet-framework', :require => 'jet'
  #
  # Then, activate it in development mode. In config/development.rb:
  #
  #   !!!ruby
  #   config.jet_enabled = true
  #   config.jet_app_path = 'app/assets'
  #
  class Railtie < ::Rails::Railtie
    config.jet_enabled = false
    config.jet_app_path = 'app/assets'

    initializer "jet" do |app|
      if config.jet_enabled
        jet_app_path = File.join(Rails.root, config.jet_app_path)
        config.app_middleware.insert(ActionDispatch::Static, Jet::Middleware, :root_path => jet_app_path)
      end
    end
  end
end
