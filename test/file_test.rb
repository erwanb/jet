require 'test_helper'

describe Jet::File do
  describe '#is_javascript?' do
    ['js', 'coffee', 'hbs'].each do |extension|
      it "returns true with file extension \"#{extension}\"" do
        assert Jet::File.is_javascript?("file.#{extension}")
      end
    end

    ['txt', 'html', 'css'].each do |extension|
      it "returns false with file extension \"#{extension}\"" do
        assert !Jet::File.is_javascript?("file.#{extension}")
      end
    end
  end

  describe '#is_stylesheet?' do
    ['css', 'sass', 'scss'].each do |extension|
      it "returns true with file extension \"#{extension}\"" do
        assert Jet::File.is_stylesheet?("file.#{extension}")
      end
    end

    ['txt', 'html', 'js'].each do |extension|
      it "returns false with file extension \"#{extension}\"" do
        assert !Jet::File.is_stylesheet?("file.#{extension}")
      end
    end
  end

  describe "#is_static?" do
    it 'returns true if path starts with \"static\"' do
      assert Jet::File.is_static?('static/index.html')
    end

    it 'returns false if path doesn\'t starts with \"static\"' do
      assert !Jet::File.is_static?('app/static/index.html')
    end
  end
end
