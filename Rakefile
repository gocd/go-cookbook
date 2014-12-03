require 'foodcritic'
require 'kitchen'
require 'rubocop/rake_task'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any'],
      tags: %w(~FC005)
    }
  end
end

desc 'Run all style checks'
task style: ['style:ruby', 'style:chef']

# Integration tests. Kitchen.ci
namespace :integration do
  desc 'Run Test Kitchen with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end
end

# Default
task default: ['style', 'integration:vagrant']
