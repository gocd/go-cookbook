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

package_path = File.join(Chef::Config[:file_cache_path], go_agent_package_name)

remote_file go_agent_package_name do
  path package_path
  source go_agent_package_url
end

autoregister_values = agent_properties

if autoregister_values[:go_server_url].nil?
  autoregister_values[:go_server_url] = 'https://localhost:8154/go'
  Chef::Log.warn("Go server not found on Chef server or not specifed via node['gocd']['agent']['go_server_url'] attribute, defaulting Go server to #{autoregister_values[:go_server_url]}")
end

opts = []
opts << "/SERVERURL='#{autoregister_values[:go_server_url]}'"
opts << '/S'
opts << '/D=C:\GoAgent'

windows_package 'Go Agent' do
  installer_type :nsis
  source package_path
  options opts.join(' ')
end
