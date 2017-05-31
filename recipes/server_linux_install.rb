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

include_recipe 'gocd::java'
include_recipe 'gocd::ohai'

package 'unzip'

case node['gocd']['install_method']
when 'repository'
  include_recipe 'gocd::repository'
  package 'go-server' do
    if latest_version?
      action :upgrade
    else
      version user_requested_version
    end
    notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
  end
when 'package_file'
  package_path = File.join(Chef::Config[:file_cache_path], go_server_package_name)
  remote_file go_server_package_name do
    path package_path
    source go_server_package_url
    mode 0644
  end
  case node['platform_family']
  when 'debian'
    dpkg_package 'go-server' do
      source package_path
      notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
    end
  when 'rhel', 'fedora'
    rpm_package 'go-server' do
      source package_path
      notifies :reload, 'ohai[reload_passwd_for_go_user]', :immediately
    end
  end
else
  raise "Unknown install method - '#{node['gocd']['install_method']}'"
end
