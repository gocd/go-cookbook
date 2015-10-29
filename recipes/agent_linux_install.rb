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
    version node['gocd']['version']
  end
when 'package_file'
  remote_file node['gocd']['agent']['package_file']['filename'] do
    path node['gocd']['agent']['package_file']['path']
    source node['gocd']['agent']['package_file']['url']
    mode 0644
  end
  case node['platform_family']
  when 'debian'
    dpkg_package 'go-agent' do
      source node['gocd']['agent']['package_file']['path']
      notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
    end
  when 'rhel','fedora'
    rpm_package 'go-agent' do
      source node['gocd']['agent']['package_file']['path']
      notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
    end
  end
else
  fail "Unknown install method - '#{node['gocd']['install_method']}'"
end
