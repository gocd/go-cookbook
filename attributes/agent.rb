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

default['gocd']['agent']['golang']['repository']['uri'] = 'https://dl.bintray.com/alex-hal9000/gocd-golang-agent'
default['gocd']['agent']['golang']['repository']['apt']['components'] = ['main']
default['gocd']['agent']['golang']['repository']['apt']['distribution'] = 'master'
default['gocd']['agent']['golang']['repository']['apt']['keyserver'] = 'hkp://keyserver.ubuntu.com:80'
default['gocd']['agent']['golang']['repository']['apt']['key'] = '379CE192D401AB61'
