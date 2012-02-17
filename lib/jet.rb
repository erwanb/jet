require 'sprockets'

module Jet
  require 'jet/utils'
  require 'jet/handlebars_template'

  Sprockets.register_engine '.hbs', HandlebarsTemplate

  require 'jet/cli'
  require 'jet/application'
  require 'jet/file'
end
