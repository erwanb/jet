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

  describe 'paths' do
    describe '#build_path' do
      [:development, :production].each do |environment|
        it "return PROJECT_DIR/build/#{environment} for environment \"#{environment}\"" do
          @application = Jet::Application.new(:environment => environment)
          @application.build_path.must_equal(Pathname.new(File.join(Dir.pwd, 'build', environment.to_s)))
        end
      end
    end

    describe '#tmp_path' do
      it 'return PROJECT_DIR/tmp' do
        @application = Jet::Application.new
        @application.tmp_path.must_equal(Pathname.new(File.join(Dir.pwd, 'tmp')))
      end
    end

    describe '#public_path' do
      it 'return PROJECT_DIR/public' do
        @application = Jet::Application.new
        @application.public_path.must_equal(Pathname.new(File.join(Dir.pwd, 'public')))
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

    describe 'Watcher' do
      describe '#run_on_change' do
        it 'builds javascript if a file is javascript' do
          @application.expects(:build_javascript).once
          @application.run_on_change(['app/js_file.js'])
        end

        it 'does not build javascript if there are no js files' do
          @application.expects(:build_javascript).never
          @application.run_on_change(['app/no_js_file.txt'])
        end

        it 'builds javascript only once if there are multiple js files' do
          @application.expects(:build_javascript).once
          @application.run_on_change(['app/js_file1.js', 'app/js_file2.js'])
        end

        it 'builds stylesheet if a file is stylesheet' do
          @application.expects(:build_stylesheet).once
          @application.run_on_change(['app/css_file.css'])
        end

        it 'does not build stylesheet if there are no css files' do
          @application.expects(:build_stylesheet).never
          @application.run_on_change(['app/no_css_file.txt'])
        end

        it 'builds stylesheet only once if there are multiple css files' do
          @application.expects(:build_stylesheet).once
          @application.run_on_change(['app/css_file1.css', 'app/css_file2.css'])
        end

        it 'copies file to build if a file is public' do
          @application.expects(:copy_to_build).with('public/file.txt').once
          @application.run_on_change(['public/file.txt'])
        end

        it 'does not copy file to build if there are no public files' do
          @application.expects(:copy_to_build).never
          @application.run_on_change(['app/file.txt'])
        end

        it 'copies each public file to build' do
          @application.expects(:copy_to_build).with('public/file1.txt').once
          @application.expects(:copy_to_build).with('public/file2.txt').once
          @application.run_on_change(['public/file1.txt', 'public/file2.txt'])
        end

        it 'works when js/css/public files change at the same time' do
          @application.expects(:copy_to_build).with('public/file.txt').once
          @application.expects(:build_stylesheet).once
          @application.expects(:build_javascript).once
          @application.run_on_change(['public/file.txt', 'app/js_file.js', 'app/css_file.css'])
        end

        it 'does not build javascript if file is js but public' do
          @application.expects(:build_javascript).never
          @application.expects(:copy_to_build).with('public/js_file.js').once
          @application.run_on_change(['public/js_file.js'])
        end

        it 'does not build stylesheet if file is css but public' do
          @application.expects(:build_stylesheet).never
          @application.expects(:copy_to_build).with('public/css_file.css').once
          @application.run_on_change(['public/css_file.css'])
        end

        it 'does nothing if file is neither public nor javascript nor stylesheet' do
          @application.expects(:build_stylesheet).never
          @application.expects(:build_javascript).never
          @application.expects(:copy_to_build).never
          @application.run_on_change(['app/txt_file.txt'])
        end
      end
    end
  end
end
