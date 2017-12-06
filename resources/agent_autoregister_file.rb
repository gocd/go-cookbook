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

default_action :create if defined?(default_action)

property :path, name_attribute: true, kind_of: String

property :owner, kind_of: String, required: false, default: 'go'
property :group, kind_of: String, required: false, default: 'go'
property :autoregister_key, kind_of: String, required: true, default: nil
property :autoregister_hostname, kind_of: String, required: false, default: nil
property :autoregister_environments, kind_of: [String, Array], required: false, default: nil
property :autoregister_resources, kind_of: [String, Array], required: false, default: nil
property :elastic_agent_id, kind_of: [String, nil], required: false, default: nil
property :elastic_agent_plugin_id, kind_of: [String, nil], required: false, default: nil

action :create do
  autoregister_values = agent_properties
  autoregister_values[:key] = new_resource.autoregister_key || autoregister_values[:key]
  autoregister_values[:hostname] = new_resource.autoregister_hostname || autoregister_values[:hostname]
  autoregister_values[:autoregister_environments] = new_resource.autoregister_environments || autoregister_values[:environments]
  autoregister_values[:autoregister_resources] = new_resource.autoregister_resources || autoregister_values[:resources]
  autoregister_values[:elastic_agent_id] = new_resource.elastic_agent_id || autoregister_values[:elastic_agent_id]
  autoregister_values[:elastic_agent_plugin_id] = new_resource.elastic_agent_plugin_id || autoregister_values[:elastic_agent_plugin_id]

  if node['platform_family'].include?('windows')
    template new_resource.path do
      source 'autoregister.properties.erb'
      cookbook 'gocd'
      variables autoregister_values
    end
  else
    template new_resource.path do
      source 'autoregister.properties.erb'
      cookbook 'gocd'
      mode     '0644'
      owner    new_resource.owner
      group    new_resource.group
      variables autoregister_values
    end
  end
end

action :delete do
  file new_resource.path do
    action :delete
  end
end
