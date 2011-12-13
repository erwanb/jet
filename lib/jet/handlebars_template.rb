require 'tilt'

module Jet
  class HandlebarsTemplate < Tilt::Template
    def self.default_mime_type
      'application/javascript'
    end

    def evaluate(scope, locals, &block)
      "Ember.Handlebars.compile(\"#{data}\")"
    end

    def prepare
    end

    def data
      Utils.escape_javascript(super)
    end
  end
end
