include_recipe 'gocd::agent_linux_install'

node['gocd']['agent']['count'].times do |i|
  name = (i == 0) ? 'go-agent' : "go-agent-#{i}"
  gocd_agent name
end
