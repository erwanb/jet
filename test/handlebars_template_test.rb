require 'test_helper'

describe Jet::HandlebarsTemplate do
  it 'should be registered by Sprockets' do
    Sprockets.engines('hbs').must_equal(Jet::HandlebarsTemplate)
    Sprockets.engines('.hbs').must_equal(Jet::HandlebarsTemplate)
  end

  it 'has a javascript mime type' do
    asset = handlebars_asset

    asset.content_type.must_equal('application/javascript')
  end

  it 'escapes data' do
    Jet::Utils.expects(:escape_javascript).with("this is a test template\n").returns('escaped javascript')
    asset = handlebars_asset

    asset.to_s.must_match(/escaped javascript/)
  end

  it 'render javascript code to compile template with SproutCore flavor of Handlebars' do
    asset = handlebars_asset
    body = asset.body

    body.must_be_instance_of(String)
    body.must_equal("SC.Handlebars.compile(\"this is a test template\\n\");\n")
  end

  def handlebars_asset
    @handlebar_asset ||= sprockets_environment['hbs_template']
  end

  def sprockets_environment
    return @sprockets_environment if defined? @sprockets_environment

    @sprockets_environment = Sprockets::Environment.new
    @sprockets_environment.append_path(File.join(File.dirname(__FILE__), 'fixtures'))
    @sprockets_environment
  end
end
