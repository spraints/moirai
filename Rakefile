require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new do |task|
  task.rspec_opts = '--color'
end

desc "Run irb with Moirai loaded"
task :irb do
  sh "irb -I lib -r moirai"
end
