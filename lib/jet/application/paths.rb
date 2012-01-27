module Jet
  class Application
    module Paths
      attr_reader :root_path

      def build_path
        @build_path  ||= root_path.join('build', environment.to_s)
      end

      def static_path
        @static_path ||= root_path.join('static')
      end

      def tmp_path
        @tmp_path ||= root_path.join('tmp')
      end

      def test_path
        @test_path ||= root_path.join('test')
      end

      def prototypes_path
        @prototypes_path ||= test_path.join('prototypes')
      end
    end
  end
end
