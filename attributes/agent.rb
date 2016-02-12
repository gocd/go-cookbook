default['gocd']['agent']['go_server_host'] = nil
default['gocd']['agent']['go_server_port'] = 8153
default['gocd']['agent']['daemon']         = true

default['gocd']['agent']['vnc']['enabled']  = false

default['gocd']['agent']['autoregister']['key']          = nil
default['gocd']['agent']['autoregister']['environments'] = %w()
default['gocd']['agent']['autoregister']['resources']    = %w()
default['gocd']['agent']['autoregister']['hostname']     = node['fqdn']
default['gocd']['agent']['server_search_query'] = "chef_environment:#{node.chef_environment} AND recipes:gocd\\:\\:server"
default['gocd']['agent']['workspace'] = nil # '/var/lib/go-agent' on linux
default['gocd']['agent']['count'] = 1
