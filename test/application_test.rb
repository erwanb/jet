require 'test_helper'

describe Jet::Application do
  def setup
    @application = Jet::Application.new
  end

  it 'sets environment to :development by default' do
    @application.environment.must_equal(:development)
  end

  describe "Compass configuration" do
    it 'sets project path to current directory' do
      Compass.configuration.project_path.must_equal(Dir.pwd)
    end

    [:development, :production].each do |environment|
      it "sets image dir to build/#{environment} for environment \"#{environment}\"" do
        @application = Jet::Application.new(environment)
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
end
