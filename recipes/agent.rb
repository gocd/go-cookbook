include_recipe 'apt'
include_recipe 'java'

go_server               = node[:go][:agent][:server_host]
package_url             = node[:go][:agent][:package_url]
package_checksum        = node[:go][:agent][:package_checksum]
go_server_autoregister  = node[:go][:agent][:auto_register]
autoregister_key        = node[:go][:agent][:auto_register_key]

apt_repository "thoughtworks" do
  uri "http://download01.thoughtworks.com/go/debian"
  components ["contrib/"]
end

package "go-agent" do
  version node[:go][:version]
  options "--force-yes"
  notifies :start, 'service[go-agent]', :immediately
end
  
if Chef::Config[:solo] || node.attribute.go?(:server)
  Chef::Log.warn("Chef-solo invocation detected or node[:go][:server attribute specified].  node[:go][:server] attribute will be used for server instance configuration.")
else
  if node
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

