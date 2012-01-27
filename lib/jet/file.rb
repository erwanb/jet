module Jet
  class File
    class << self
      JAVASCRIPT_EXTENSIONS = ['.js', '.coffee', '.hbs']
      STYLESHEET_EXTENSIONS = ['.css', '.sass', '.scss']

      def is_javascript?(file)
        JAVASCRIPT_EXTENSIONS.include?(::File.extname(file))
      end

      def is_stylesheet?(file)
        STYLESHEET_EXTENSIONS.include?(::File.extname(file))
      end

      def is_static?(file)
        ::File.dirname(file) =~ /^!?static/
      end

      def is_deleted?(file)
        file =~ /^!/
      end

      def is_prototype?(file)
        file =~ /^!?test\/prototypes/
      end
    end
  end
end
