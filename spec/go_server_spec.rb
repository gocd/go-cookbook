require 'spec_helper'

describe 'gocd::server' do
  shared_examples_for :server_recipe do
    it 'includes java recipe' do
      expect(chef_run).to include_recipe('java::default')
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
    it 'installs go-server package' do
      expect(chef_run).to install_package('go-server')
    end
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
    it 'installs go-server package' do
      expect(chef_run).to install_package('go-server')
    end
  end
  #TODO: server on windows

  context 'When installing from package_file and platform is debian' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new do |node|
        node.automatic['lsb']['id'] = 'Debian'
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform'] = 'debian'
        node.automatic['os'] = 'linux'
        node.normal['gocd']['install_method'] = 'package_file'
      end
      run.converge(described_recipe)
    end
    it_behaves_like :server_recipe
    it 'downloads go-server .deb from remote URL' do
      expect(chef_run).to create_remote_file('go-server-15.2.0-2248.deb').with(
        source: 'http://download.go.cd/gocd-deb/go-server-15.2.0-2248.deb')
    end
    it 'installs go-server package from file' do
      expect(chef_run).to install_dpkg_package('go-server')
    end
  end
  context 'When installing from package file and platform is centos' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new do |node|
        node.automatic['platform_family'] = 'rhel'
        node.automatic['platform'] = 'centos'
        node.automatic['os'] = 'linux'
        node.normal['gocd']['install_method'] = 'package_file'
      end
      run.converge(described_recipe)
    end
    it_behaves_like :server_recipe
    it 'downloads go-server .rpm from remote URL' do
      expect(chef_run).to create_remote_file('go-server-15.2.0-2248.noarch.rpm').with(
        source: 'http://download.go.cd/gocd-rpm/go-server-15.2.0-2248.noarch.rpm')
    end
    it 'installs go-server package from file' do
      expect(chef_run).to install_rpm_package('go-server')
    end
  end
end
