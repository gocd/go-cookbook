# Since we're running on a single node we can just use 127.0.0.1 for the server IP. Search isn't necessary

case node['platform']
when 'windows'
  include_recipe "go::agent_windows"
else
  node.default['go']['server'] = '127.0.0.1'
  include_recipe "go::server"
  include_recipe "go::agent_linux"
end

Chef::Log.info("Node has #{node['cpu']['total']} CPUs")
