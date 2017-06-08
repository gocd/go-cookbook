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

require 'spec_helper'

describe 'gocd::agent' do
  shared_examples_for :agent_recipe_windows do
    it 'configures go-agent service' do
      expect(chef_run).to enable_service('Go Agent')
      expect(chef_run).to start_service('Go Agent')
    end
  end

  context 'When all attributes are default and platform is windows' do
    it_behaves_like :agent_recipe_windows
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_agent') do |node|
        node.automatic['platform_family'] = 'windows'
        node.automatic['platform'] = 'windows'
        node.automatic['os'] = 'windows'
        node.normal['gocd']['agent']['go_server_url'] = 'https://localhost:8154/go'
      end
      allow_any_instance_of(Chef::Resource::RemoteFile).to receive(:fetch_content)
        .and_return('{"message": "{\"latest-version\": \"16.2.1-3027\"}"}')
      run.converge(described_recipe)
    end

    it 'downloads official installer' do
      expect(chef_run).to create_remote_file('go-agent-stable-setup.exe').with(
        source: 'https://download.gocd.org/binaries/16.2.1-3027/win/go-agent-16.2.1-3027-setup.exe')
    end
    it 'installs go-agent package' do
      expect(chef_run).to install_windows_package('Go Agent')
    end
  end

  context 'When installing from custom url and platform is windows' do
    it_behaves_like :agent_recipe_windows
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_agent') do |node|
        node.automatic['platform_family'] = 'windows'
        node.automatic['platform'] = 'windows'
        node.automatic['os'] = 'windows'
        node.normal['gocd']['agent']['go_server_url'] = 'https://localhost:8154/go'
        node.normal['gocd']['agent']['package_file']['url'] = 'https://example.com/go-agent.exe'
      end
      run.converge(described_recipe)
    end
    it 'downloads specified installer' do
      expect(chef_run).to create_remote_file('go-agent-custom-setup.exe').with(
        source: 'https://example.com/go-agent.exe')
    end
    it 'installs go-agent package' do
      expect(chef_run).to install_windows_package('Go Agent')
    end
  end
end
