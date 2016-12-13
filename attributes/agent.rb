default['gocd']['agent']['go_server_url']  = nil
default['gocd']['agent']['daemon']         = true

default['gocd']['agent']['vnc']['enabled'] = false

default['gocd']['agent']['type'] = 'java'

default['gocd']['agent']['autoregister']['key']          = nil
default['gocd']['agent']['autoregister']['environments'] = %w()
default['gocd']['agent']['autoregister']['resources']    = %w()
default['gocd']['agent']['autoregister']['hostname']     = node['fqdn']

default['gocd']['agent']['elastic']['plugin_id'] = nil
default['gocd']['agent']['elastic']['agent_id'] = nil

default['gocd']['agent']['server_search_query'] = "chef_environment:#{node.chef_environment} AND recipes:gocd\\:\\:server"
default['gocd']['agent']['workspace']           = nil # '/var/lib/go-agent' on linux
default['gocd']['agent']['count']               = 1
default['gocd']['agent']['default_extras']      = {}

default['gocd']['agent']['golang']['version'] = '1.6'
