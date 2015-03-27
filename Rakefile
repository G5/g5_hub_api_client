#require 'bundler'
require 'bundler/gem_tasks'
require 'rspec'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks
desc 'Run all examples'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec
