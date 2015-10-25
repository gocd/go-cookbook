include_recipe "gocd::agent_linux_install"

for i in 0..(node['gocd']['agent']['count'] -1)
  name = "go-agent-#{i}"
  name = "go-agent" if i == 0
  gocd_agent name
end
