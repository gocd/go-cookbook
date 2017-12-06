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

property :plugin_name, name_attribute: true, kind_of: String, required: true
property :plugin_uri, kind_of: String, required: true
property :server_work_dir, kind_of: String, required: false, default: node['gocd']['server']['work_dir']

action :create do
  include_recipe 'gocd::server_linux_install'

  plugin_name = new_resource.plugin_name
  server_work_dir = new_resource.server_work_dir
  plugin_uri = new_resource.plugin_uri
  remote_file "#{server_work_dir}/plugins/external/#{plugin_name}.jar" do
    source plugin_uri
    owner 'go'
    group 'go'
    mode 0770
    retries 5
  end
end
