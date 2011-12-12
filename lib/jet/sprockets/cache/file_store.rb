module Jet
  module Sprockets
    module Cache
      # This store acts like Sprockets::Cache::FileStore except it does not cache 'application.css'.
      #
      # PROBLEM:
      # If application.css is cached, sprite (see compass spriting) won't be generated until application.css is modified.
      # This is problematic when we are rebuilding the app upon booting and application.css is already cached.
      #
      # SOLUTION:
      # The simple solution is to not cache application.css with sprockets (it is cached by sass anyway).
      class FileStore < ::Sprockets::Cache::FileStore
        def []=(key, value)
          return value if value['logical_path'] == 'application.css'
          super
        end
      end
    end
  end
end
