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
  package_options = node['gocd']['repository']['apt']['package_options'] if node['platform_family'] == 'debian'
  package "go-server" do
    version node['gocd']['version']
    options package_options
    notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
  end
when 'package_file'
  remote_file node['gocd']['server']['package_file']['filename'] do
    path node['gocd']['server']['package_file']['path']
    source node['gocd']['server']['package_file']['url']
    mode 0644
  end
  case node['platform_family']
  when 'debian'
    dpkg_package 'go-server' do
      source node['gocd']['server']['package_file']['path']
      notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
    end
  when 'rhel','fedora'
    rpm_package 'go-server' do
      source node['gocd']['server']['package_file']['path']
      notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
    end
  end
else
  fail "Unknown install method - '#{node['gocd']['install_method']}'"
end
