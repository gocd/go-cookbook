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
      allow_any_instance_of(Chef::Resource::RemoteFile).to receive(:fetch_content)
        .and_return('{"message": "{\"latest-version\": \"16.2.1-3027\"}"}')
      run.converge(described_recipe)
    end

    it 'downloads official installer' do
      expect(chef_run).to create_remote_file('go-server-stable-setup.exe').with(
        source: 'https://download.gocd.io/binaries/16.2.1-3027/win/go-server-16.2.1-3027-setup.exe')
    end

    it 'installs go-server package' do
      expect(chef_run).to install_windows_package('Go Server')
    end
  end

  context 'When experimental flag is set and platform is windows' do
    it_behaves_like :service_recipe_windows
    let(:chef_run) do
      run = ChefSpec::SoloRunner.new(step_into: 'gocd_server') do |node|
        node.automatic['platform_family'] = 'windows'
        node.automatic['platform'] = 'windows'
        node.automatic['os'] = 'windows'
        node.normal['gocd']['use_experimental'] = true
      end
      allow_any_instance_of(Chef::Resource::RemoteFile).to receive(:fetch_content)
        .with('https://update.gocd.io/channels/experimental/latest.json')
        .and_return('{"message": "{\"latest-version\": \"20.1.2-12345\"}"}')
      run.converge(described_recipe)
    end

    it 'downloads official experimental installer' do
      expect(chef_run).to create_remote_file('go-server-experimental-setup.exe').with(
        source: 'https://download.gocd.io/binaries/20.1.2-12345/win/go-server-20.1.2-12345-setup.exe')
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

    it 'downloads specified installer' do
      expect(chef_run).to create_remote_file('go-server-custom-setup.exe').with(
        source: 'https://example.com/go-server.exe')
    end

    it 'installs go-server package' do
      expect(chef_run).to install_windows_package('Go Server')
    end
  end
end
