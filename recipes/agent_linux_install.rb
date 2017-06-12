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

include_recipe 'gocd::ohai'

case node['gocd']['agent']['type']
when 'java'
  include_recipe 'gocd::java' if node['gocd']['agent']['type'] == 'java'

  case node['gocd']['install_method']
  when 'repository'
    include_recipe 'gocd::repository'
    package 'go-agent' do
      notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
      if latest_version?
        action :upgrade
      else
        version user_requested_version
      end
    end
  when 'package_file'
    package_path = File.join(Chef::Config[:file_cache_path], go_agent_package_name)
    remote_file go_agent_package_name do
      path package_path
      source go_agent_package_url
      mode 00644
    end
    case node['platform_family']
    when 'debian'
      dpkg_package 'go-agent' do
        source package_path
        notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
      end
    when 'rhel', 'fedora'
      rpm_package 'go-agent' do
        source package_path
        notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
      end
    end
  else
    raise "Unknown install method - '#{node['gocd']['install_method']}'"
  end
when 'golang'
  case node['platform_family']
  when 'debian'
    include_recipe 'apt'
    agent_version = node['gocd']['agent']['golang']['version']
    remote_file '/usr/bin/gocd-golang-agent' do
      source "https://bintray.com/gocd-contrib/gocd_golang_goagent/download_file?file_path=goagent%2F#{agent_version}%2Fgocd-golang-agent_#{os}_#{arch}_#{agent_version}"
      mode 00755
      owner 'root'
      group 'root'
    end
  else
    raise 'golang agent installation is only supported on debian-based systems'
  end
else
  raise "Invalid go-agent type #{node['gocd']['agent']['type']}. Possible options are java, golang"
end
