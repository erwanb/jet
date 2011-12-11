require 'test_helper'

describe Jet::Application do
  before do
    @application = Jet::Application.new
  end

  describe 'Initialization' do
    describe 'application directory' do
      it 'is set to current directory by default' do
        @application.root_path.must_equal(Pathname.new(Dir.pwd))
      end

      it 'can be set in options hash' do
        application = Jet::Application.new(:root_path => fixtures_path.to_s)
        application.root_path.must_equal(fixtures_path)
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

    it 'change current dir to project path' do
      project_path = fixtures_path.join('test_project').to_s
      @application = Jet::Application.new(:root_path => project_path)
      Dir.pwd.must_equal(project_path)
    end
  end

  describe '#build_path' do
    [:development, :production].each do |environment|
      it "return PROJECT_DIR/build/#{environment} for environment \"#{environment}\"" do
        @application = Jet::Application.new(:environment => environment)
        @application.build_path.must_equal(@application.root_path.join('build', environment.to_s))
      end
    end
  end

  describe "Compass configuration" do
    it 'sets project path to current directory' do
      Compass.configuration.project_path.must_equal(Pathname.new(Dir.pwd))
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
      @application = Jet::Application.new(:root_path => fixtures_path.join('test_project').to_s)
    end

    after do
      @application.clear_build
    end

    describe '#clear_build' do
      it 'delete all files in build directory' do
        FileUtils.touch(@application.build_path.join('test_file'))
        FileUtils.mkdir(@application.build_path.join('test_directory'))
        @application.clear_build
        Dir.glob(@application.build_path.join('*')).must_be_empty
      end
    end

    describe '#build_javascript' do
      it 'writes config/boot.js to build dir as "application.js"' do
        expected_path = @application.build_path.join('application.js')
        @application.build_javascript
        assert expected_path.exist?
        IO.read(expected_path).must_equal("var boot = \"I am boot.js\";\n")
      end
    end

    describe '#build_stylesheet' do
      it 'writes app/stylesheets/application.css to build dir as "application.css"' do
        expected_path = @application.build_path.join('application.css')
        @application.build_stylesheet
        assert expected_path.exist?
        IO.read(expected_path).must_equal("html{color:black}\n")
      end
    end

    describe 'Sprite building' do
      it 'generates a sprite' do
        @application = Jet::Application.new(:root_path => fixtures_path.join('sprite_test').to_s)
        @application.build_stylesheet
        Dir[@application.build_path.join('images-*.png')].size.must_equal(1)
      end

      it 'delete old sprite before generating a new one' do
        @application = Jet::Application.new(:root_path => fixtures_path.join('sprite_test').to_s)
        stylesheet_path = @application.root_path.join('app/stylesheets/application.css.scss')

        # Build stylesheet a first time and check that the sprite is generated
        @application.build_stylesheet
        old_sprite_path = Dir[@application.build_path.join('images-*.png')].first
        assert File.exist?(old_sprite_path)

        # Then add a new images and modify the stylesheet. If we don't do that a new sprite won't be generated
        FileUtils.cp(fixtures_path.join('book.png'), @application.root_path.join('app/images/'))
        File.open(stylesheet_path, File::WRONLY|File::APPEND) do |file|
          file.write("\n")
        end

        # Build stylesheet once again and verify that the old sprite has been replaced by a new one
        @application.build_stylesheet
        assert !File.exist?(old_sprite_path), 'Old sprite file should not exist'
        Dir[@application.build_path.join('images-*.png')].size.must_equal(1)

        # Teardown
        FileUtils.rm(@application.root_path.join('app/images/book.png'))
        stylesheet_content = IO.read(stylesheet_path).chomp
        File.open(stylesheet_path, "w") do |file|
          file.print(stylesheet_content)
        end
      end
    end

    describe '#copy_static_assets_to_build' do
      it 'copies public/ to the build directory' do
        @application.copy_static_assets_to_build

        def files_relative_to(parent_path)
          Dir[parent_path.join('**/*')].map do |absolute_path|
            Pathname.new(absolute_path).relative_path_from(parent_path)
          end
        end

        expected_files = files_relative_to(@application.root_path.join('public'))
        existing_files = files_relative_to(@application.build_path)
        expected_files.must_equal(existing_files)
      end
    end

    describe '#copy_to_build' do
      it 'copy a file at the root of public/ to the root of build dir' do
        @application.copy_to_build(File.join('public', 'index.html'))
        assert @application.build_path.join('index.html').exist?
      end

      it 'create parent dirs of a file in build dir if they don\'t exist' do
        @application.copy_to_build(File.join('public', 'test_dir', 'test_file'))
        assert @application.build_path.join('test_dir', 'test_file').exist?
        assert @application.build_path.join('test_dir', 'test_file').file?
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
