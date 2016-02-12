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
      end
      run.converge(described_recipe)
    end

    it 'installs go-agent package' do
      expect(chef_run).to install_package('Go Agent').with(
        :source => 'https://download.go.cd/binaries/16.1.0-2855/win/go-agent-16.1.0-2855-setup.exe'
      )
    end
  end

  context 'When installing from custom url and platform is windows' do
    it_behaves_like :agent_recipe_windows
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_agent') do |node|
        node.automatic['platform_family'] = 'windows'
        node.automatic['platform'] = 'windows'
        node.automatic['os'] = 'windows'
        node.normal['gocd']['agent']['package_file']['url'] = 'https://example.com/go-agent.exe'
      end
      run.converge(described_recipe)
    end

    it 'installs go-agent package' do
      expect(chef_run).to install_package('Go Agent').with(
        :source => 'https://example.com/go-agent.exe'
      )
    end
  end
end
