require 'test_helper'
require 'jet/middleware'

describe Jet::Middleware do
  describe 'Initialization' do
    it 'rebuilds app and start watching' do
      application = mock
      application.stub_everything
      Jet::Application.stubs(:new).returns(application)
      app_init = sequence('app_init')

      application.stubs(:build_path).returns('test')
      application.expects(:clear).in_sequence(app_init)
      application.expects(:build).in_sequence(app_init)
      application.expects(:watch).in_sequence(app_init)
      middleware = Jet::Middleware.new(nil)
    end
  end

  describe '#call' do
    before do
      Dir.chdir(fixtures_path.join('test_project'))

      app = lambda { |env| [404, {}, ['not found']] }

      @request = Rack::MockRequest.new(Jet::Middleware.new(app))
    end

    it 'serves files in build dir' do
      response = @request.get('/index.html')

      assert response.ok?
      response.body.must_match(/test_project index/)
    end

    it 'serves index.html when requesting a directory' do
      response = @request.get('/')

      assert response.ok?
      response.body.must_match(/test_project index/)
    end

    it "ignores directories without index.html" do
      response = @request.get('/empty_dir')

      response.status.must_equal(404)
      response.body.must_equal('not found')
    end

    it 'waits until app is built to serve /index.html' do
      serve = sequence('serve')

      Jet::Application.any_instance.expects(:wait_until_built).once.in_sequence(serve)
      Rack::File.any_instance.expects(:call).once.returns([200, {}, '']).in_sequence(serve)

      @request.get('/index.html')
    end

    it 'falls back to the app' do
      response = @request.get('notfound_request')

      response.status.must_equal(404)
      response.body.must_equal('not found')
    end
  end
end
