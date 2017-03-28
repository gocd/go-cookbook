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

    it 'upgrades go-server package if version is set to `latest`' do
      chef_run.node.set['gocd']['version'] = 'latest'
      chef_run.converge(described_recipe)
      expect(chef_run).to upgrade_package('go-server')
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
    it 'upgrades go-server package if version is set to `latest`' do
      chef_run.node.set['gocd']['version'] = 'latest'
      chef_run.converge(described_recipe)
      expect(chef_run).to upgrade_package('go-server')
    end
  end
  # TODO: server on windows

  context 'When installing from package_file and platform is debian' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new do |node|
        node.automatic['lsb']['id'] = 'Debian'
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform'] = 'debian'
        node.automatic['os'] = 'linux'
        node.normal['gocd']['install_method'] = 'package_file'
      end
      allow_any_instance_of(Chef::Resource::RemoteFile).to receive(:fetch_content)
        .and_return('{"message": "{\"latest-version\": \"16.2.1-3027\"}"}')
      run.converge(described_recipe)
    end
    it_behaves_like :server_recipe
    it 'downloads go-server .deb from remote URL' do
      expect(chef_run).to create_remote_file('go-server-stable.deb').with(
        source: 'https://download.gocd.io/binaries/16.2.1-3027/deb/go-server_16.2.1-3027_all.deb')
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
      allow_any_instance_of(Chef::Resource::RemoteFile).to receive(:fetch_content)
        .and_return('{"message": "{\"latest-version\": \"16.2.1-3027\"}"}')
      run.converge(described_recipe)
    end
    it_behaves_like :server_recipe
    it 'downloads go-server .rpm from remote URL' do
      expect(chef_run).to create_remote_file('go-server-stable.noarch.rpm').with(
        source: 'https://download.gocd.io/binaries/16.2.1-3027/rpm/go-server-16.2.1-3027.noarch.rpm')
    end
    it 'installs go-server package from file' do
      expect(chef_run).to install_rpm_package('go-server')
    end
  end

  context 'When installing from custom repository and platform is debian' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new do |node|
        node.automatic['lsb']['id'] = 'Debian'
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform'] = 'debian'
        node.automatic['os'] = 'linux'
        node.normal['gocd']['install_method'] = 'repository'
        node.normal['gocd']['repository']['apt']['uri'] = 'http://mydeb/repo'
        node.normal['gocd']['repository']['apt']['components'] = ['/']
        node.normal['gocd']['repository']['apt']['key'] = false
      end
      run.converge(described_recipe)
    end
    it_behaves_like :server_recipe
    it 'includes apt recipe' do
      expect(chef_run).to include_recipe('apt')
    end
    it 'adds my custom gocd apt repository' do
      expect(chef_run).to add_apt_repository('gocd').with(
        uri: 'http://mydeb/repo',
        key: nil,
        components: ['/'])
    end

    it 'installs go-server package' do
      expect(chef_run).to install_package('go-server')
    end

    it 'upgrades go-server package if version is set to `latest`' do
      chef_run.node.set['gocd']['version'] = 'latest'
      chef_run.converge(described_recipe)
      expect(chef_run).to upgrade_package('go-server')
    end
  end
  context 'When installing from custom repository and platform is centos' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new do |node|
        node.automatic['platform_family'] = 'rhel'
        node.automatic['platform'] = 'centos'
        node.automatic['os'] = 'linux'
        node.normal['gocd']['install_method'] = 'repository'
        node.normal['gocd']['repository']['yum']['baseurl'] = 'http://mycustom/gocd-rpm'
      end
      run.converge(described_recipe)
    end
    it_behaves_like :server_recipe
    it 'includes yum recipe' do
      expect(chef_run).to include_recipe('yum')
    end
    it 'adds my custom gocd yum repository' do
      expect(chef_run).to create_yum_repository('gocd').with(
        baseurl: 'http://mycustom/gocd-rpm',
        gpgcheck: true
      )
    end

    it 'installs go-server package' do
      expect(chef_run).to install_package('go-server')
    end

    it 'upgrades go-server package if version is set to `latest`' do
      chef_run.node.set['gocd']['version'] = 'latest'
      chef_run.converge(described_recipe)
      expect(chef_run).to upgrade_package('go-server')
    end
  end
end
