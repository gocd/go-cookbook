require 'spec_helper'

describe 'gocd::server' do
  shared_examples_for :service_recipe_windows do
    it 'configures go-server service' do
      expect(chef_run).to enable_service('Go Server')
      expect(chef_run).to start_service('Go Server')
    end
  end

  context 'When all attributes are default and platform is windows' do
    it_behaves_like :service_recipe_windows
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_server') do |node|
        node.automatic['platform_family'] = 'windows'
        node.automatic['platform'] = 'windows'
        node.automatic['os'] = 'windows'
      end
      run.converge(described_recipe)
    end

    it 'installs go-server package' do
      expect(chef_run).to install_package('Go Server').with(
        :source => 'https://download.go.cd/binaries/16.1.0-2855/win/go-server-16.1.0-2855-setup.exe'
      )
    end
  end

  context 'When installing from custom url and platform is windows' do
    it_behaves_like :service_recipe_windows
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_server') do |node|
        node.automatic['platform_family'] = 'windows'
        node.automatic['platform'] = 'windows'
        node.automatic['os'] = 'windows'
        node.normal['gocd']['server']['package_file']['url'] = 'https://example.com/go-server.exe'
      end
      run.converge(described_recipe)
    end

    it 'installs go-server package' do
      expect(chef_run).to install_package('Go Server').with(
        :source => 'https://example.com/go-server.exe'
      )
    end
  end
end
