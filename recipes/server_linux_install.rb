include_recipe "gocd::java"

ohai 'reload_passwd_for_go_user' do
  name 'reload_passwd'
  action :nothing
  plugin 'etc'
end

package 'unzip'

case node['gocd']['install_method']
when 'repository'
  include_recipe 'gocd::repository'
  package "go-server" do
    if latest_version?
      action :upgrade
    else
      version user_requested_version
    end
    notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
  end
when 'package_file'
  package_path = File.join(Chef::Config[:file_cache_path], go_server_package_name)
  remote_file go_server_package_name do
    path package_path
    source go_server_package_url
    mode 0644
  end
  case node['platform_family']
  when 'debian'
    dpkg_package 'go-server' do
      source package_path
      notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
    end
  when 'rhel','fedora'
    rpm_package 'go-server' do
      source package_path
      notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
    end
  end
else
  fail "Unknown install method - '#{node['gocd']['install_method']}'"
end
