##########################################################################
# Copyright 2017 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

require 'foodcritic'
require 'kitchen'
require 'rspec/core/rake_task'
require 'cookstyle'
require 'rubocop/rake_task'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby) do |task|
    task.options << '--display-cop-names'
    # task.options << '--auto-correct' # use it for fixing linting errors locally
  end

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any'],
      tags: %w(~FC005),
    }
  end
end

desc 'Run all style checks'
task style: ['style:ruby', 'style:chef']

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
    config = Kitchen::Config.new(loader: @loader)
    config.instances.each do |instance|
      instance.test(:always)
    end
  end

  desc 'Run Test Kitchen with openstack (private)'
  task :openstack do
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.openstack.yml')
    config = Kitchen::Config.new(loader: @loader)
    config.instances.each do |instance|
      instance.test(:always)
    end
  end

  desc 'Run Test Kitchen with docker'
  task :docker do
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.docker.yml')
    config = Kitchen::Config.new(loader: @loader)
    config.instances.each do |instance|
      instance.test(:always)
    end
  end
end

# Default
task default: ['style', 'integration:vagrant']
