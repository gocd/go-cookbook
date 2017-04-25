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

if defined?(ChefSpec)
  def create_gocd_agent(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gocd_agent, :create, resource_name)
  end

  def delete_gocd_agent(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gocd_agent, :delete, resource_name)
  end

  def create_gocd_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gocd_plugin, :create, resource_name)
  end

  def create_gocd_agent_autoregister_file(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gocd_agent_autoregister_file, :create, resource_name)
  end

  def delete_gocd_agent_autoregister_file(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gocd_agent_autoregister_file, :delete, resource_name)
  end
end
