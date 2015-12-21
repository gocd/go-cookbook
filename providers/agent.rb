use_inline_resources

action :create do
  run_context.include_recipe 'gocd::agent_linux_install'

  agent_name = new_resource.agent_name
  workspace = new_resource.workspace || "/var/lib/#{agent_name}"
  [workspace, "/var/log/#{agent_name}"].each do |d|
    directory d do
      mode     0755
      owner    new_resource.user
      group    new_resource.group
    end
  end
  directory "#{workspace}/config" do
    mode     0700
    owner    new_resource.user
    group    new_resource.group
  end
  # package manages the init.d/go-agent script so cookbook should not.
  bash "setup init.d for #{agent_name}" do
    code <<-EOH
    cp /etc/init.d/go-agent /etc/init.d/#{agent_name}
    sed -i 's/# Provides: go-agent$/# Provides: #{agent_name}/g' /etc/init.d/#{agent_name}
    EOH
    not_if "grep -q '# Provides: #{agent_name}$' /etc/init.d/#{agent_name}"
    only_if { agent_name != 'go-agent' }
  end
  link "/usr/share/#{agent_name}" do
    to "/usr/share/go-agent"
    not_if { agent_name == 'go-agent' }
  end

  autoregister_values = get_agent_properties
  autoregister_values[:go_server_host] = new_resource.go_server_host || autoregister_values[:go_server_host]
  autoregister_values[:go_server_port] = new_resource.go_server_port || autoregister_values[:go_server_port]
  autoregister_values[:key] =  new_resource.autoregister_key || autoregister_values[:key]
  autoregister_values[:hostname] = new_resource.autoregister_hostname || autoregister_values[:hostname]
  autoregister_values[:environments] = new_resource.environments || autoregister_values[:environments]
  autoregister_values[:resources] = new_resource.resources || autoregister_values[:resources]
  autoregister_values[:vnc] = new_resource.vnc || autoregister_values[:vnc]
  autoregister_values[:daemon] = new_resource.vnc || autoregister_values[:daemon]
  autoregister_values[:workspace] = workspace
  if autoregister_values[:go_server_host].nil?
    autoregister_values[:go_server_host] = '127.0.0.1'
    Chef::Log.warn("Go server not found on Chef server or not specifed via node['gocd']['agent']['go_server_host'] attribute, defaulting Go server to #{autoregister_values[:go_server_host]}")
  end

  template "/etc/default/#{agent_name}" do
    source   "go-agent-default.erb"
    cookbook 'gocd'
    mode     "0644"
    owner    "root"
    group    "root"
    notifies :restart,      "service[#{agent_name}]" if autoregister_values[:daemon]
    variables autoregister_values
  end

  if autoregister_values[:key]
    template "#{workspace}/config/autoregister.properties" do
      source  'autoregister.properties.erb'
      cookbook 'gocd'
      mode     "0644"
      owner    new_resource.user
      group    new_resource.group
      not_if { ::File.exists? ("#{workspace}/config/agent.jks") }
      notifies :restart, "service[#{agent_name}]" if autoregister_values[:daemon]
      variables autoregister_values
    end
  end

  service agent_name do
    supports :status => true, :restart => autoregister_values[:daemon], :start => true, :stop => true
    action   new_resource.service_action
  end
end
