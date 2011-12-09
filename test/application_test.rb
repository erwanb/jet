require 'test_helper'

describe Jet::Application do
  def setup
    @application = Jet::Application.new
  end

  describe 'Initialization' do
    describe 'application directory' do
      it 'is set to current directory by default' do
        @application.root_path.must_equal(Dir.pwd)
      end

      it 'can be set in options hash' do
        application = Jet::Application.new(:root_path => 'test/path')
        application.root_path.must_equal('test/path')
      end
    end

    describe 'environment' do
      it 'is set to :development by default' do
        @application.environment.must_equal(:development)
      end

      it 'can be set in options hash' do
        application = Jet::Application.new(:environment => :production)
        application.environment.must_equal(:production)
      end
    end
  end

  describe '#build_path' do
    [:development, :production].each do |environment|
      it "return PROJECT_DIR/build/#{environment} for environment \"#{environment}\"" do
        @application = Jet::Application.new(:environment => environment)
        @application.build_path.must_equal(File.join(@application.root_path, 'build', environment.to_s))
      end
    end
  end

  describe "Compass configuration" do
    it 'sets project path to current directory' do
      Compass.configuration.project_path.must_equal(Dir.pwd)
    end

    [:development, :production].each do |environment|
      it "sets image dir to build/#{environment} for environment \"#{environment}\"" do
        @application = Jet::Application.new(:environment => environment)
        Compass.configuration.images_dir.must_equal("build/#{environment}")
      end
    end

    it 'sets images_path to "app"' do
      Compass.configuration.images_path.must_equal('app')
    end

    it 'makes images accessibles at the http root path' do
      Compass.configuration.http_images_dir.must_equal('/')
    end
  end

  describe "Builder" do
    before do
      @application = Jet::Application.new(:root_path => File.join(File.dirname(__FILE__), 'fixtures', 'test_project'))
      @application.clear_build
    end

    describe '#clear_build' do
      it 'delete all files in build directory' do
        FileUtils.touch(File.join(@application.build_path, 'test_file'))
        FileUtils.mkdir(File.join(@application.build_path, 'test_directory'))
        @application.clear_build
        Dir.glob(File.join(@application.build_path, '*')).must_be_empty
      end
    end

    describe '#build_javascript' do
      it 'writes config/boot.js to build dir as "application.js"' do
        expected_path = File.join(@application.build_path, 'application.js')
        @application.build_javascript
        assert File.exist?(expected_path)
        IO.read(expected_path).must_equal("var boot = \"I am boot.js\";\n")
      end
    end

    describe '#build_stylesheet' do
      it 'writes app/stylesheets/application.css to build dir as "application.css"' do
        expected_path = File.join(@application.build_path, 'application.css')
        @application.build_stylesheet
        assert File.exist?(expected_path)
        IO.read(expected_path).must_equal("html{color:black}\n")
      end
    end

    describe '#copy_static_assets_to_build' do
      it 'copies public/ to the build directory' do
        @application.copy_static_assets_to_build

        def files_relative_to(parent_path)
          parent_path = Pathname.new(parent_path)

          Dir[File.join(parent_path, '**/*')].map do |absolute_path|
            Pathname.new(absolute_path).relative_path_from(parent_path)
          end
        end

        expected_files = files_relative_to(File.join(@application.root_path, 'public'))
        existing_files = files_relative_to(@application.build_path)
        expected_files.must_equal(existing_files)
      end
    end

    describe '#copy_to_build' do
      it 'copy a file at the root of public/ to the root of build dir' do
        @application.copy_to_build(File.join('public', 'index.html'))
        assert File.exist?(File.join(@application.build_path, 'index.html'))
      end

      it 'create parent dirs of a file in build dir if they don\'t exist' do
        @application.copy_to_build(File.join('public', 'test_dir', 'test_file'))
        assert File.exist?(File.join(@application.build_path, 'test_dir', 'test_file'))
        assert File.file?(File.join(@application.build_path, 'test_dir', 'test_file'))
        IO.read(File.join(@application.build_path, 'test_dir', 'test_file')).must_equal("test_file\n")
      end
    end

    describe '#build_all' do
      it 'build javascript, stylesheets and copy public dir to build dir' do
        @application.expects(:build_javascript).once
        @application.expects(:build_stylesheet).once
        @application.expects(:copy_static_assets_to_build).once
        @application.build_all
      end
    end
  end
end
