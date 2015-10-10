require 'foodcritic'
require 'kitchen'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any'],
      tags: %w(~FC005)
    }
  end
end

desc 'Run all style checks'
task style: ['style:chef']

# Integration tests. Kitchen.ci
namespace :integration do
  desc 'Run Test Kitchen with Vagrant'
  task :vagrant do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end

  desc 'Run Test Kitchen with cloud plugins'
  task :cloud, :pattern do
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.cloud.yml')
    config = Kitchen::Config.new( loader: @loader)
    config.instances.each do |instance|
      instance.test(:always)
    end
  end

  desc 'Run Test Kitchen with docker'
  task :docker do
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.docker.yml')
    config = Kitchen::Config.new( loader: @loader)
    config.instances.each do |instance|
      instance.test(:always)
    end
  end
end

# Default
task default: ['style', 'integration:vagrant']
