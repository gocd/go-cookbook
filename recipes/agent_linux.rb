include_recipe 'gocd::repository'
include_recipe "gocd::java"

package "go-agent" do
  notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
end

ohai 'reload_passwd_for_go_user' do
  name 'reload_passwd'
  action :nothing
  plugin 'etc'
end

directory '/var/lib/go-agent/config' do
  mode     "0700"
  owner    "go"
  group    "go"
end

if Chef::Config['solo'] || node['gocd']['agent']['go_server_host']
  Chef::Log.info("Attempting to use node['gocd']['agent']['go_server_host'] attribute for server host")
  go_server_host   = node['gocd']['agent']['go_server_host']
  autoregister_key = node['gocd']['agent']['autoregister']['key']
else
  server_search_query = node['gocd']['agent']['server_search_query']
  Chef::Log.info("Search query: #{server_search_query}")
  go_servers = search(:node, server_search_query)
  if go_servers.count == 0
    Chef::Log.warn("No Go servers found on any of the nodes running chef client.")
  else
    go_server = go_servers.first
    go_server_host = go_server['ipaddress']
    if go_servers.count > 1
      Chef::Log.warn("Multiple Go servers found on Chef server. Using first returned server '#{go_server_host}' for server instance configuration.")
    end
    Chef::Log.info("Found Go server at ip address #{go_server_host} with automatic agent registration")
    if autoregister_key = go_server['gocd']['server']['autoregister_key']
      Chef::Log.warn("Agent auto-registration enabled. This agent will not require approval to become active.")
    end
  end
end

if go_server_host.nil?
  go_server_host = '127.0.0.1'
  Chef::Log.warn("Go server not found on Chef server or not specifed via node['gocd']['agent']['go_server_host'] attribute, defaulting Go server to #{go_server_host}")
end

template "/etc/default/go-agent" do
  source   "go-agent-default.erb"
  mode     "0644"
  owner    "root"
  group    "root"
  notifies :restart,      "service[go-agent]"
  variables({
    host: go_server_host
  })
end

if autoregister_key
  template '/var/lib/go-agent/config/autoregister.properties' do
    mode     "0644"
    owner    "go"
    group    "go"
    not_if { File.exists? ("/var/lib/go-agent/config/agent.jks") }
    notifies :restart,      "service[go-agent]"
    variables({
                key:            autoregister_key,
                hostname:       node['gocd']['agent']['autoregister']['hostname'],
                environments:   node['gocd']['agent']['autoregister']['environments'],
                resources:      node['gocd']['agent']['autoregister']['resources'],
    })
  end
end

service "go-agent" do
  supports :status => true, :restart => true, :start => true, :stop => true
  action [:enable, :start]
end
