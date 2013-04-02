default[:go][:release] = "13.1.1"
default[:go][:build] = "#{node[:go][:release]}-16714"
default[:go][:server_download_url] = "http://download01.thoughtworks.com/go/#{node[:go][:release]}/ga/go-server-#{node[:go][:build]}.deb"
default[:go][:agent_download_url] = "http://download01.thoughtworks.com/go/#{node[:go][:release]}/ga/go-agent-#{node[:go][:build]}.deb"
default[:go][:backup_path] = ""

default[:go][:auto_register_agents] = false
