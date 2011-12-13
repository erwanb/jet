require 'sprockets'
require 'tilt'

module Sprockets
  class JstProcessor < Tilt::Template
    def self.default_namespace
      'this.Ember.TEMPLATES'
    end
  end
end
