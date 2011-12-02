require 'sprockets'
require 'tilt'

module Sprockets
  class JstProcessor < Tilt::Template
    def self.default_namespace
      'this.SC.TEMPLATES'
    end
  end
end
