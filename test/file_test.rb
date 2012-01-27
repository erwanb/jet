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

    it 'returns true if path is a static asset being deleted' do
      assert Jet::File.is_static?('!static/index.html')
    end

    it 'returns false if path doesn\'t starts with \"static\"' do
      assert !Jet::File.is_static?('app/static/index.html')
    end
  end

  describe "#is_prototype?" do
    it 'returns true if path starts with \"test/prototypes\"' do
      assert Jet::File.is_prototype?('test/prototypes/test.html')
    end

    it 'returns true if path is a prototype asset being deleted' do
      assert Jet::File.is_prototype?('!test/prototypes/test.html')
    end

    it 'returns false if path doesn\'t starts with \"test/prototypes/test.html\"' do
      assert !Jet::File.is_prototype?('prototypes/test.html')
    end
  end
end
