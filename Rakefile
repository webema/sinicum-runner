require "bundler/gem_tasks"

require 'rspec/core/rake_task'

Dir[File.expand_path('../lib/tasks/**/*rake', __FILE__)].each do |file|
  load file
end

desc "Runs the tests"
RSpec::Core::RakeTask.new(:spec)

task default: [:spec, :maven_test]
