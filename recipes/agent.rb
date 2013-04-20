include_recipe 'java'

package_url = node['go']['agent']['package_url']
package_checksum = node['go']['agent']['package_cheksum']

remote_file "/tmp/go-agent.deb" do
  source package_url
  mode '0644'
  checksum package_checksum
end

dpkg_package "install-go-agent" do
  source "/tmp/go-agent.deb"
  notifies :start, 'service[go-agent]', :immediately
end

if Chef::Config[:solo]
  Chef::Log.warn("Chef-solo invocation detected.  node[:go][:server] attribute used for server instance configuration.")
  go_server = node[:go][:server]
  go_server_autoregister = node[:go][:auto_register_agents]
  autoregister_key = node[:go][:auto_register_agents_key]
else
  go_servers = search(:node, "chef_environment:#{node.chef_environment} AND recipes:go-server")
  go_server = "#{go_servers[0][:ipaddress]}"
  go_server_autoregister = "#{go_servers[0][:go][:auto_register_agents]}"
  Chef::Log.info("Found Go server at ip address #{go_server} with automatic agent registration=#{go_server_autoregister}")
  if (go_server_autoregister)
    Chef::Log.warn("Agent auto-registration enabled.  This agent will not require approval to become active.")
    autoregister_key = "#{go_servers[0][:go][:autoregister_key]}"
  else
    autoregister_key = ""
  end
end

template '/etc/default/go-agent' do
  Chef::Log.warn("Configuring agent for Go server at #{go_server}:8153 ")
  source 'go-agent.erb'
  mode '0644'
  owner 'go'
  group 'go'
  variables(:go_server_host => go_server, :go_server_port => '8153')
  notifies :restart, 'service[go-agent]', :immediately
  action :nothing
end

template '/var/lib/go-agent/config/autoregister.properties' do
  Chef::Log.warn("Registering agent with autoregister key of " + autoregister_key)
  source 'autoregister.properties.erb'
  group 'go'
  owner 'go'
  mode 0644
  variables(:autoregister_key => autoregister_key,
          :agent_resources => "#{node[:os]}, #{node[:platform]},#{node[:platform]}-#{node[:platform_version]}")
  action :nothing
  notifies :restart, 'service[go-agent]', :immediately
end

service 'go-agent' do
  supports :status => true, :restart => true, :reload => true, :start => true
  action [:enable]
end

