##########################################################################
# Copyright 2017 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

default['gocd']['agent']['go_server_url'] = nil
default['gocd']['agent']['daemon'] = true

default['gocd']['agent']['vnc']['enabled'] = false

default['gocd']['agent']['type'] = 'java'

default['gocd']['agent']['autoregister']['key'] = nil
default['gocd']['agent']['autoregister']['environments'] = %w()
default['gocd']['agent']['autoregister']['resources'] = %w()
default['gocd']['agent']['autoregister']['hostname'] = node['fqdn']

default['gocd']['agent']['elastic']['plugin_id'] = nil
default['gocd']['agent']['elastic']['agent_id'] = nil

default['gocd']['agent']['server_search_query'] = "chef_environment:#{node.chef_environment} AND recipes:gocd\\:\\:server"
default['gocd']['agent']['workspace'] = nil # '/var/lib/go-agent' on linux
default['gocd']['agent']['count'] = 1
default['gocd']['agent']['default_extras'] = {}

default['gocd']['agent']['golang']['version'] = '1.6'
