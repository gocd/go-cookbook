require 'spec_helper'

describe 'gocd::server' do
  shared_examples_for :server_recipe do
    it 'includes java recipe' do
      expect(chef_run).to include_recipe('java::default')
    end
    it 'installs go-server package' do
      expect(chef_run).to install_package('go-server')
    end
    it 'creates go server configuration in /etc/default/go-server' do
      expect(chef_run).to render_file('/etc/default/go-server').with_content { |content|
        expect(content).to_not include('java-6')
      }
    end
    it 'configures go-server service' do
      expect(chef_run).to enable_service('go-server')
      expect(chef_run).to start_service('go-server')
    end
  end

  context 'When all attributes are default and platform is debian' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new do |node|
        node.automatic['lsb']['id'] = 'Debian'
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform'] = 'debian'
        node.automatic['os'] = 'linux'
      end
      run.converge(described_recipe)
    end
    it_behaves_like :server_recipe
    it_behaves_like :apt_repository_recipe
  end
  context 'When all attributes are default and platform is centos' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new do |node|
        node.automatic['platform_family'] = 'rhel'
        node.automatic['platform'] = 'centos'
        node.automatic['os'] = 'linux'
      end
      run.converge(described_recipe)
    end
    it_behaves_like :server_recipe
    it_behaves_like :yum_repository_recipe
  end
  #TODO: server on windows
end
