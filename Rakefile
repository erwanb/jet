require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << ['lib', 'test']
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

desc "Run tests with code coverage"
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].execute
end
