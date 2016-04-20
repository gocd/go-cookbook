include_recipe "gocd::java"

ohai 'reload_passwd_for_go_user' do
  action :nothing
  plugin 'etc'
end

case node['gocd']['install_method']
when 'repository'
  include_recipe 'gocd::repository'
  package_options = node['gocd']['repository']['apt']['package_options'] if node['platform_family'] == 'debian'
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
