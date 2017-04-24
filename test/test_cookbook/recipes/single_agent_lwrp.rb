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

gocd_agent 'my-go-agent' do
  go_server_url 'https://go.example.com:443/go'
  daemon true
  vnc    true
  autoregister_key 'bla-key'
  autoregister_hostname 'my-lwrp-agent'
  environments 'production'
  resources     ['java-8', 'ruby-2.2']
  workspace     '/mnt/big_drive'
end
