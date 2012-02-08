require 'test_helper'

describe File do
  describe '#javascript?' do
    ['js', 'coffee', 'hbs'].each do |extension|
      it "returns true with file extension \"#{extension}\"" do
        assert File.javascript?("file.#{extension}")
      end
    end

    ['txt', 'html', 'css'].each do |extension|
      it "returns false with file extension \"#{extension}\"" do
        assert !File.javascript?("file.#{extension}")
      end
    end
  end

  describe '#stylesheet?' do
    ['css', 'sass', 'scss'].each do |extension|
      it "returns true with file extension \"#{extension}\"" do
        assert File.stylesheet?("file.#{extension}")
      end
    end

    ['txt', 'html', 'js'].each do |extension|
      it "returns false with file extension \"#{extension}\"" do
        assert !File.stylesheet?("file.#{extension}")
      end
    end
  end

  describe "#static?" do
    it 'returns true if path starts with \"static\"' do
      assert File.static?('static/index.html')
    end

    it 'returns true if path is a static asset being deleted' do
      assert File.static?('!static/index.html')
    end

    it 'returns false if path doesn\'t starts with \"static\"' do
      assert !File.static?('app/static/index.html')
    end
  end
end
