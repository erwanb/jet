require 'tilt'

module Jet
  class HandlebarsTemplate < Tilt::Template
    JS_ESCAPE_MAP = { '\\' => '\\\\', '</' => '<\/', "\r\n" => '\n', "\n" => '\n', "\r" => '\n', '"' => '\\"', "'" => "\\'" }

    def self.default_mime_type
      'application/javascript'
    end

    def evaluate(scope, locals, &block)
      "SC.Handlebars.compile(\"#{escaped_data}\")"
    end

    def prepare
    end

    private

    def escaped_data
      data.gsub(/(\\|<\/|\r\n|[\n\r"'])/) {|match| JS_ESCAPE_MAP[match] }
    end
  end
end
