module Jet
  class Application
    module Paths
      attr_reader :root_path

      def build_path
        @build_path  ||= root_path.join('build', environment.to_s)
      end

      def public_path
        @public_path ||= root_path.join('public')
      end
    end
  end
end
