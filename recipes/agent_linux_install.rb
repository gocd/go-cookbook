ohai 'reload_passwd_for_go_user' do
  action :nothing
  plugin 'etc'
end

case node['gocd']['agent']['type']
when 'java'
  include_recipe "gocd::java" if node['gocd']['agent']['type'] == 'java'

  case node['gocd']['install_method']
  when 'repository'
    include_recipe 'gocd::repository'
    package "go-agent" do
      notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
      if latest_version?
        action :upgrade
      else
        version user_requested_version
      end
    end
  when 'package_file'
    package_path = File.join(Chef::Config[:file_cache_path], go_agent_package_name)
    remote_file go_agent_package_name do
      path package_path
      source go_agent_package_url
      mode 00644
    end
    case node['platform_family']
    when 'debian'
      dpkg_package 'go-agent' do
        source package_path
        notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
      end
    when 'rhel','fedora'
      rpm_package 'go-agent' do
        source package_path
        notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
      end
    end
  else
    fail "Unknown install method - '#{node['gocd']['install_method']}'"
  end
when'golang'
  case node['platform_family']
  when 'debian'
    include_recipe 'apt'
    apt_repository 'gocd-golang-agent' do
      uri node['gocd']['agent']['golang']['repository']['uri']
      components node['gocd']['agent']['golang']['repository']['apt']['components']
      distribution node['gocd']['agent']['golang']['repository']['apt']['distribution']
      keyserver node['gocd']['agent']['golang']['repository']['apt']['keyserver'] unless node['gocd']['agent']['golang']['repository']['apt']['keyserver'] == false
      key node['gocd']['agent']['golang']['repository']['apt']['key'] unless node['gocd']['agent']['golang']['repository']['apt']['key'] == false
    end
    apt_package 'gocd-golang-agent' do
      options '--force-yes'
    end
  else
    fail 'golang agent installation is only supported on debian-based systems'
  end
else
  fail "Invalid go-agent type #{node['gocd']['agent']['type']}. Possible options are java, golang"
end
