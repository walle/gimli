require 'rake'

require 'bundler'
Bundler::GemHelper.install_tasks

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = %w(-fd -c)
  end
rescue LoadError
  desc message = %{"gem install rspec --pre" to run the specs}
  task(:spec) { abort message }
end

task :default => :spec
task :test => :spec

