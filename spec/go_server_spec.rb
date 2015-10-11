require 'spec_helper'

describe 'gocd::server' do
  describe 'debian' do
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new do |node|
        node.automatic['lsb']['id'] = 'Debian'
        node.automatic['platform_family'] = 'debian'
        node.automatic['platform'] = 'debian'
        node.automatic['os'] = 'linux'
        node.normal['java']['jdk_version'] = '7'
      end
      run.converge(described_recipe)
    end

    it 'includes apt recipe' do
      expect(chef_run).to include_recipe('apt::default')
    end
    it 'includes java recipe' do
      expect(chef_run).to include_recipe('java::default')
    end
    it 'adds thoughtworks apt repository' do
      expect(chef_run).to add_apt_repository('gocd')
    end
    it 'installs go-server apt package' do
      expect(chef_run).to install_package('go-server')
    end

    it 'creates go server configuration in /etc/default/go-server' do
      expect(chef_run).to render_file('/etc/default/go-server').with_content { |content|
        expect(content).to_not include('java-6-openjdk')
      }
    end

  end
end
