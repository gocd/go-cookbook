# Encoding: utf-8

default['go']['backup_path'] = ''
default['go']['backup_retrieval_type'] = 'subversion'

default['go']['agent']['auto_register'] = false
default['go']['agent']['auto_register_key'] = 'default_auto_registration_key'
default['go']['agent']['auto_register_resources'] = []
default['go']['agent']['auto_register_environments'] = []

# Install this many agent instances on a box - default is one per CPU

default['go']['agent']['instance_count'] = node['cpu']['total']
default['go']['agent']['server_search_query'] =
  "chef_environment:#{node.chef_environment} AND recipes:go\\:\\:server"

default['go']['version'] = '14.3.0-1186'

unless platform?('windows')
  default['go']['agent']['java_home'] = '/usr/bin/java'
end
