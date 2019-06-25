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

describe 'gocd_test::agent_autoregister_file_lwrp' do
  context 'When all attributes are default' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_agent_autoregister_file') do |node|
        node.automatic['lsb']['id'] = 'Debian'
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform'] = 'debian'
        node.automatic['os'] = 'linux'
      end
      run.converge(described_recipe)
    end

    it 'creates autoregister file chef resource' do
      expect(chef_run).to create_gocd_agent_autoregister_file('/var/mygo/autoregister.properties').with(
        autoregister_key: 'bla-key',
        autoregister_hostname: 'mygo-agent',
        autoregister_environments: 'stage',
        autoregister_resources: ['java-8', 'ruby']
      )
    end

    it 'creates autoregister properties file' do
      expect(chef_run).to render_file('/var/mygo/autoregister.properties').with_content { |content|
        expect(content).to     include('bla-key')
        expect(content).to     include('stage')
        expect(content).to     include('mygo-agent')
        expect(content).to     include('java-8, ruby')
        expect(content).to_not include('agent.auto.register.elasticAgent')
      }
    end

    it 'creates elastic autoregister file chef resource' do
      expect(chef_run).to create_gocd_agent_autoregister_file('/var/elastic/autoregister.properties').with(
        autoregister_key: 'some-key',
        autoregister_hostname: 'elastic-agent',
        autoregister_environments: 'testing',
        autoregister_resources: ['java-8']
      )
    end

    it 'creates elastic autoregister properties file' do
      expect(chef_run).to render_file('/var/elastic/autoregister.properties').with_content { |content|
        expect(content).to     include('some-key')
        expect(content).to     include('testing')
        expect(content).to     include('agent-id')
        expect(content).to     include('elastic-agent-plugin-id')
        expect(content).to     include('agent.auto.register.elasticAgent.pluginId')
        expect(content).to     include('agent.auto.register.elasticAgent.agentId')
      }
    end
  end

  context 'When autoregister values are specified in attributes' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_agent_autoregister_file') do |node|
        node.automatic['lsb']['id'] = 'Debian'
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform'] = 'debian'
        node.automatic['os'] = 'linux'
        node.normal['gocd']['agent']['autoregister']['key'] = 'some-key'
        node.normal['gocd']['agent']['autoregister']['environments'] = 'testing'
        node.normal['gocd']['agent']['autoregister']['resources'] = ['java-8']
        node.normal['gocd']['agent']['autoregister']['hostname'] = 'elastic-agent'
        node.normal['gocd']['agent']['elastic']['plugin_id'] = 'agent-id'
        node.normal['gocd']['agent']['elastic']['agent_id'] = 'elastic-agent-plugin-id'
      end
      run.converge(described_recipe)
    end
    it 'creates autoregister file' do
      expect(chef_run).to create_gocd_agent_autoregister_file('/var/attrs/autoregister.properties')
    end
    it 'renders autoregister file from attributes' do
      expect(chef_run).to render_file('/var/attrs/autoregister.properties').with_content { |content|
        expect(content).to     include('some-key')
        expect(content).to     include('elastic-agent')
        expect(content).to     include('testing')
        expect(content).to     include('java-8')
        expect(content).to     include('agent-id')
        expect(content).to     include('elastic-agent-plugin-id')
      }
    end
  end
end
