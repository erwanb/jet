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
  end
end
