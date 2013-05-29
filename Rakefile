require "bundler/gem_tasks"
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task default: :spec

task :push => :run_all_specs do
   puts "Pushing real good"
   Rake.sh 'git push origin master'
end

task :run_all_specs => :spec do
   Rake.sh 'bundle exec rspec --tag @integration'
end

desc 'Run all specs with code coverage'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
  Rake::Task['run_all_specs'].execute
end
