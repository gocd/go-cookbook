include_recipe "go::server"
include_recipe "go::agent"

Chef::Log.info("Node has #{node[:cpu][:total]} CPUs")