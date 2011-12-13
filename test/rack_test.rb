require 'test_helper'

describe Jet::Rack do
  describe 'Initialization' do
    it 'rebuilds app and start watching' do
      application = mock
      application.stub_everything
      Jet::Application.stubs(:new).returns(application)
      app_init = sequence('app_init')

      application.expects(:clear_build).in_sequence(app_init)
      application.expects(:build_all).in_sequence(app_init)
      application.expects(:watch).in_sequence(app_init)
      rack = Jet::Rack.new
    end
  end

  describe '#call' do
    before do
      Dir.chdir(fixtures_path.join('test_project'))
      @request = Rack::MockRequest.new(Jet::Rack.new)
    end

    it 'serves files in build dir' do
      response = @request.get('/index.html')

      assert response.ok?
      response.body.must_match(/test_project index/)
    end

    it 'serves /index.html when requesting /' do
      response = @request.get('/')

      assert response.ok?
      response.body.must_match(/test_project index/)
    end

    it 'waits until app is built to serve /index.html' do
      serve = sequence('serve')

      Jet::Application.any_instance.expects(:wait_until_built).once.in_sequence(serve)
      Rack::File.any_instance.expects(:call).once.returns([200, {}, '']).in_sequence(serve)

      @request.get('/')
    end

    it 'serves other assets immediatly even if app is being built' do
      Jet::Application.any_instance.expects(:wait_until_built).never
      @request.get('/404.html')
    end
  end
end
