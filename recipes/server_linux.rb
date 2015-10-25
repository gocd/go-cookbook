include_recipe 'gocd::repository'
include_recipe "gocd::java"

package "go-server" do
  notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
end

ohai 'reload_passwd_for_go_user' do
  name 'reload_passwd'
  action :nothing
  plugin 'etc'
end

template "/etc/default/go-server" do
  source   "go-server-default.erb"
  mode     "0644"
  owner    "root"
  group    "root"
  notifies :restart, "service[go-server]", :immediately
end

service "go-server" do
  supports :status => true, :restart => true, :start => true, :stop => true
  action [:enable, :start]
  notifies :get, 'http_request[verify_go-server_comes_up]', :immediately
end

http_request 'verify_go-server_comes_up' do
  url         "http://localhost:#{node['gocd']['server']['http_port']}/go/home"
  retry_delay 10
  retries     10
  action      :nothing
end

ruby_block "publish_autoregister_key" do
  block do
    s = ::File.readlines('/etc/go/cruise-config.xml').grep(/agentAutoRegisterKey="(\S+)"/)
    if s.length > 0
      server_autoregister_key = s[0].to_s.match(/agentAutoRegisterKey="(\S+)"/)[1]
    else
      server_autoregister_key = nil
    end
    Chef::Log.warn("Enabling automatic agent registration. Any configured agent will be configured to build without authorization.")
    node.set['gocd']['server']['autoregister_key'] = server_autoregister_key
    node.save
  end
  action :create
  not_if { Chef::Config[:solo] }
end
