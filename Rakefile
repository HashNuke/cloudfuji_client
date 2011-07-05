require 'rake/testtask'
require 'bundler'
require 'ci/reporter/rake/test_unit'

Bundler::GemHelper.install_tasks

task :default => :test

desc "Run bushido tests"
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
