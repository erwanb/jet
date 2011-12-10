module Jet
  module Utils
    JS_ESCAPE_MAP = {
      '\\'   => '\\\\',
      '</'   => '<\/',
      "\r\n" => '\n',
      "\n"   => '\n',
      "\r"   => '\n',
      '"'    => '\\"',
      "'"    => "\\'"
    }

    # taken from Rails
    # See : https://github.com/rails/rails/blob/master/actionpack/lib/action_view/helpers/javascript_helper.rb
    def self.escape_javascript(javascript)
      javascript.gsub(/(\\|<\/|\r\n|[\n\r"'])/) {|match| JS_ESCAPE_MAP[match] }
    end

    def self.camelize(term)
      term.split(/[^a-z0-9]/i).map{|w| w.capitalize}.join
    end
  end
end
