class File
  class << self
    JAVASCRIPT_EXTENSIONS = ['.js', '.coffee', '.hbs']
    STYLESHEET_EXTENSIONS = ['.css', '.sass', '.scss']

    def javascript?(file)
      JAVASCRIPT_EXTENSIONS.include?(extname(file))
    end

    def stylesheet?(file)
      STYLESHEET_EXTENSIONS.include?(extname(file))
    end

    def static?(file)
      dirname(file) =~ /^!?static/
    end

    def deleted?(file)
      file =~ /^!/
    end
  end
end
