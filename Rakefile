require 'foodcritic'
require 'kitchen'
require 'rspec/core/rake_task'

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

task unit: ['unit:chefspec']
namespace 'unit' do
  desc 'Run Chefspec tests of this cookbook (spec/*_spec.rb)'
  RSpec::Core::RakeTask.new(:chefspec_internal) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rspec_opts = [].tap do |a|
      a.push('--color')
      a.push('--format documentation')
      a.push('--format h')
      a.push('--out ./chefspec.html')
    end.join(' ')
  end

  desc 'Run Chefspec tests of this cookbook (spec/*_spec.rb), updates deps'
  task chefspec: [:chefspec_internal]

  desc 'Remove all .html reports files'
  task :clean_reports do
    Dir['./**/*.html'].each do |file_path|
      rm file_path
    end
  end
end

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

  desc 'Run Test Kitchen with openstack (private)'
  task :openstack do
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.openstack.yml')
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
