# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'jet/version'

Gem::Specification.new do |s|
  s.name        = 'jet-framework'
  s.platform    = Gem::Platform::RUBY
  s.version     = Jet::VERSION
  s.authors     = ['Erwan Barrier']
  s.email       = ['erwan.barrier@gmail.com']
  s.homepage    = 'http://github.com/erwanb/jet'
  s.summary     = 'The Jet build tool gem'
  s.description = 'Jet is a build tool for SproutCore 2'

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = 'jet-framework'

  s.add_dependency 'thor'
  s.add_dependency 'sprockets'
  s.add_dependency 'coffee-script'
  s.add_dependency 'compass', ">= 0.12.alpha.2"
  s.add_dependency 'sprockets-sass'
  s.add_dependency 'guard'
  s.add_dependency 'rack'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'simplecov'

  s.files        = Dir.glob('{lib,bin}/**/{*,.*}') + %w[LICENSE README.md]
  s.test_files   = Dir.glob('test/**/*')
  s.executables  = ['jet']
  s.require_path = 'lib'
end
