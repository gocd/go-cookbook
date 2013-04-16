
include_recipe 'java'

# Only re-download the remote file if it changes.  http_request HEAD detects the change and triggers the download
remote_file "#{Chef::Config[:file_cache_path]}/go-agent-#{node[:go][:build]}.deb" do
  source node[:go][:agent_download_url]
  mode 0644
  action :nothing
  notifies :install, 'dpkg_package[install-go-agent]', :immediately
end

http_request "HEAD #{node[:go][:agent_download_url]}" do
  message ""
  url node[:go][:agent_download_url]
  action :head
  if File.exists?("#{Chef::Config[:file_cache_path]}/go-agent-#{node[:go][:build]}.deb")
    headers "If-Modified-Since" => File.mtime("#{Chef::Config[:file_cache_path]}/go-agent-#{node[:go][:build]}.deb").httpdate
  end
  # notifies :create, resources(:remote_file => "#{Chef::Config[:file_cache_path]}/go-agent-#{node[:go][:build]}.deb"), :immediately
  notifies :create, "remote_file[#{Chef::Config[:file_cache_path]}/go-agent-#{node[:go][:build]}.deb]", :immediately
end

dpkg_package "install-go-agent" do
  action :nothing
  version node[:go][:release]
  source "#{Chef::Config[:file_cache_path]}/go-agent-#{node[:go][:build]}.deb"
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
  supports :status => true, :restart => true, :reload => true
  action [:enable]
end

