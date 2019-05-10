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

gocd_agent_autoregister_file '/var/mygo/autoregister.properties' do
  autoregister_key 'bla-key'
  autoregister_hostname 'mygo-agent'
  autoregister_environments 'stage'
  autoregister_resources ['java-8', 'ruby']
end

gocd_agent_autoregister_file '/var/elastic/autoregister.properties' do
  autoregister_key 'some-key'
  autoregister_hostname 'elastic-agent'
  autoregister_environments 'testing'
  autoregister_resources ['java-8']
  elastic_agent_id 'agent-id'
  elastic_agent_plugin_id 'elastic-agent-plugin-id'
end

gocd_agent_autoregister_file '/var/attrs/autoregister.properties' do
  autoregister_key 'some-key'
end
