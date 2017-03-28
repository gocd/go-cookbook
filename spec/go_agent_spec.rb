require 'spec_helper'

describe 'gocd::agent' do
  shared_examples_for :agent_recipe_linux do
    it_behaves_like :agent_linux_install
    it 'creates go agent configuration in /etc/default/go-agent' do
      expect(chef_run).to render_file('/etc/default/go-agent').with_content { |content|
        expect(content).to_not include('java-6')
        expect(content).to     include('GO_SERVER_URL=https://localhost:8154/go')
        expect(content).to_not include('GO_SERVER_PORT=8153')
        expect(content).to     include('AGENT_WORK_DIR=/var/lib/go-agent')
        expect(content).to     include('DAEMON=Y')
        expect(content).to     include('VNC=N')
      }
    end
    it 'creates gocd_agent chef resource' do
      expect(chef_run).to create_gocd_agent('go-agent')
    end
    it 'configures go-agent service' do
      expect(chef_run).to enable_service('go-agent')
      expect(chef_run).to start_service('go-agent')
    end
    it 'creates go agent workspace directory' do
      expect(chef_run).to create_directory('/var/lib/go-agent').with(
        owner: 'go',
        group: 'go',
        mode:  0755
      )
    end
    it 'creates go agent log directory' do
      expect(chef_run).to create_directory('/var/log/go-agent').with(
        owner: 'go',
        group: 'go',
        mode:  0755
      )
    end
    it 'creates go agent config directory' do
      expect(chef_run).to create_directory('/var/lib/go-agent/config').with(
        owner: 'go',
        group: 'go',
        mode:  0700
      )
    end
  end

  context 'When attributes use obsolete go server host and port and platform is debian' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_agent') do |node|
        node.automatic['lsb']['id'] = 'Debian'
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform'] = 'debian'
        node.automatic['os'] = 'linux'
        node.normal['gocd']['agent']['go_server_host'] = 'localhost'
      end
      run.converge(described_recipe)
    end
    before do
      stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
    end
    it_behaves_like :agent_recipe_linux
    it_behaves_like :apt_repository_recipe
    it 'warns about obsolete attributes use' do
      expect(chef_run).to write_log('Warn obsolete attributes')
    end
    it 'installs go-agent package' do
      expect(chef_run).to install_package('go-agent')
    end

    it 'upgrades go-agent package if version is set to `latest`' do
      chef_run.node.set['gocd']['version'] = 'latest'
      chef_run.converge(described_recipe)
      expect(chef_run).to upgrade_package('go-agent')
    end
  end

  context 'When all attributes are default and platform is debian' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_agent') do |node|
        node.automatic['lsb']['id'] = 'Debian'
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform'] = 'debian'
        node.automatic['os'] = 'linux'
        node.normal['gocd']['agent']['go_server_url'] = 'https://localhost:8154/go'
      end
      run.converge(described_recipe)
    end
    before do
      stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
    end
    it_behaves_like :agent_recipe_linux
    it_behaves_like :apt_repository_recipe
    it 'installs go-agent package' do
      expect(chef_run).to install_package('go-agent')
    end

    it 'upgrades go-agent package if version is set to `latest`' do
      chef_run.node.set['gocd']['version'] = 'latest'
      chef_run.converge(described_recipe)
      expect(chef_run).to upgrade_package('go-agent')
    end
  end
  context 'When all attributes are default and platform is centos' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_agent') do |node|
        node.automatic['platform_family'] = 'rhel'
        node.automatic['platform'] = 'centos'
        node.automatic['os'] = 'linux'
        node.normal['gocd']['agent']['go_server_url'] = 'https://localhost:8154/go'
      end
      run.converge(described_recipe)
    end
    before do
      stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
    end
    it_behaves_like :agent_recipe_linux
    it_behaves_like :yum_repository_recipe
    it 'installs go-agent package' do
      expect(chef_run).to install_package('go-agent')
    end

    it 'upgrades go-agent package if version is set to `latest`' do
      chef_run.node.set['gocd']['version'] = 'latest'
      chef_run.converge(described_recipe)
      expect(chef_run).to upgrade_package('go-agent')
    end
  end

  context 'When many agents and all attributes are default and platform is debian' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_agent') do |node|
        node.automatic['lsb']['id'] = 'Debian'
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform'] = 'debian'
        node.automatic['os'] = 'linux'
        node.normal['gocd']['agent']['go_server_url'] = 'https://localhost:8154/go'
        node.normal['gocd']['agent']['count'] = 2
      end
      run.converge(described_recipe)
    end
    before do
      stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
      stub_command("grep -q '# Provides: go-agent-1$' /etc/init.d/go-agent-1").and_return(false)
    end
    it_behaves_like :agent_recipe_linux
    it_behaves_like :apt_repository_recipe
    it 'installs go-agent package' do
      expect(chef_run).to install_package('go-agent')
    end

    it 'upgrades go-agent package if version is set to `latest`' do
      chef_run.node.set['gocd']['version'] = 'latest'
      chef_run.converge(described_recipe)
      expect(chef_run).to upgrade_package('go-agent')
    end

    # https://github.com/gocd/gocd/blob/master/installers/agent/release/README.md
    it 'creates additional gocd_agent chef resource' do
      expect(chef_run).to create_gocd_agent('go-agent-1')
    end
    it 'creates init.d script to start additional agent' do
      expect(chef_run).to run_bash('setup init.d for go-agent-1')
    end
    it 'links /usr/share/go-agent script' do
      expect(chef_run).to create_link('/usr/share/go-agent-1').with(
        to: '/usr/share/go-agent'
      )
    end
    it 'creates go-agent-1 configuration' do
      expect(chef_run).to render_file('/etc/default/go-agent-1')
      # TODO: check content
    end
    it 'creates additional go agent workspace directory' do
      expect(chef_run).to create_directory('/var/lib/go-agent-1').with(
        owner: 'go',
        group: 'go',
        mode:  0755
      )
    end
    it 'creates additional go agent log directory' do
      expect(chef_run).to create_directory('/var/log/go-agent-1').with(
        owner: 'go',
        group: 'go',
        mode:  0755
      )
    end
    it 'creates additional go agent config directory' do
      expect(chef_run).to create_directory('/var/lib/go-agent-1/config').with(
        owner: 'go',
        group: 'go',
        mode:  0700
      )
    end
    it 'configures additional go-agent service' do
      expect(chef_run).to enable_service('go-agent-1')
      expect(chef_run).to start_service('go-agent-1')
    end
  end

  context 'When installing from package_file and platform is debian' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_agent') do |node|
        node.automatic['lsb']['id'] = 'Debian'
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform'] = 'debian'
        node.automatic['os'] = 'linux'
        node.normal['gocd']['agent']['go_server_url'] = 'https://localhost:8154/go'
        node.normal['gocd']['install_method'] = 'package_file'
      end
      allow_any_instance_of(Chef::Resource::RemoteFile).to receive(:fetch_content)
        .with('https://update.gocd.io/channels/supported/latest.json')
        .and_return('{"message": "{\"latest-version\": \"16.2.1-3027\"}"}')
      run.converge(described_recipe)
    end
    before do
      stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
    end
    it_behaves_like :agent_recipe_linux
    it 'downloads go-agent .deb from remote URL' do
      expect(chef_run).to create_remote_file('go-agent-stable.deb').with(
        source: 'https://download.gocd.io/binaries/16.2.1-3027/deb/go-agent_16.2.1-3027_all.deb')
    end
    it 'installs go-agent package from file' do
      expect(chef_run).to install_dpkg_package('go-agent')
    end
  end
  context 'When installing from package file and platform is centos' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_agent') do |node|
        node.automatic['platform_family'] = 'rhel'
        node.automatic['platform'] = 'centos'
        node.automatic['os'] = 'linux'
        node.normal['gocd']['agent']['go_server_url'] = 'https://localhost:8154/go'
        node.normal['gocd']['install_method'] = 'package_file'
      end
      allow_any_instance_of(Chef::Resource::RemoteFile).to receive(:fetch_content)
        .and_return('{"message": "{\"latest-version\": \"16.2.1-3027\"}"}')
      run.converge(described_recipe)
    end
    before do
      stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
    end
    it_behaves_like :agent_recipe_linux
    it 'downloads go-agent .rpm from remote URL' do
      expect(chef_run).to create_remote_file('go-agent-stable.noarch.rpm').with(
        source: 'https://download.gocd.io/binaries/16.2.1-3027/rpm/go-agent-16.2.1-3027.noarch.rpm')
    end
    it 'installs go-agent package from file' do
      expect(chef_run).to install_rpm_package('go-agent')
    end
  end

  context 'When installing from custom repository and platform is debian' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_agent') do |node|
        node.automatic['lsb']['id'] = 'Debian'
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform'] = 'debian'
        node.automatic['os'] = 'linux'
        node.normal['gocd']['agent']['go_server_url'] = 'https://localhost:8154/go'
        node.normal['gocd']['install_method'] = 'repository'
        node.normal['gocd']['repository']['apt']['uri'] = 'http://mydeb/repo'
        node.normal['gocd']['repository']['apt']['components'] = ['/']
        node.normal['gocd']['repository']['apt']['key'] = false
      end
      run.converge(described_recipe)
    end
    before do
      stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
    end
    it_behaves_like :agent_recipe_linux
    it 'includes apt recipe' do
      expect(chef_run).to include_recipe('apt')
    end
    it 'adds my custom gocd apt repository' do
      expect(chef_run).to add_apt_repository('gocd').with(
        uri: 'http://mydeb/repo',
        key: nil,
        components: ['/'])
    end
    it 'installs go-agent package' do
      expect(chef_run).to install_package('go-agent')
    end

    it 'upgrades go-agent package if version is set to `latest`' do
      chef_run.node.set['gocd']['version'] = 'latest'
      chef_run.converge(described_recipe)
      expect(chef_run).to upgrade_package('go-agent')
    end
  end
  context 'When installing from custom repository and platform is centos' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_agent') do |node|
        node.automatic['platform_family'] = 'rhel'
        node.automatic['platform'] = 'centos'
        node.automatic['os'] = 'linux'
        node.normal['gocd']['agent']['go_server_url'] = 'https://localhost:8154/go'
        node.normal['gocd']['install_method'] = 'repository'
        node.normal['gocd']['repository']['yum']['baseurl'] = 'http://mycustom/gocd-rpm'
      end
      run.converge(described_recipe)
    end
    before do
      stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
    end
    it_behaves_like :agent_recipe_linux
    it 'includes yum recipe' do
      expect(chef_run).to include_recipe('yum')
    end
    it 'adds my custom gocd yum repository' do
      expect(chef_run).to create_yum_repository('gocd').with(
        baseurl: 'http://mycustom/gocd-rpm',
        gpgcheck: true
      )
    end

    it 'installs go-agent package' do
      expect(chef_run).to install_package('go-agent')
    end

    it 'upgrades go-agent package if version is set to `latest`' do
      chef_run.node.set['gocd']['version'] = 'latest'
      chef_run.converge(described_recipe)
      expect(chef_run).to upgrade_package('go-agent')
    end
  end
end
