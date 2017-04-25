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

case node['platform_family']
when 'debian'
  include_recipe 'apt'

  apt_repository 'gocd' do
    uri apt_uri
    components node['gocd']['repository']['apt']['components']
    distribution node['gocd']['repository']['apt']['distribution']
    keyserver node['gocd']['repository']['apt']['keyserver'] unless node['gocd']['repository']['apt']['keyserver'] == false
    key node['gocd']['repository']['apt']['key'] unless node['gocd']['repository']['apt']['key'] == false
  end

when 'rhel', 'fedora'
  include_recipe 'yum'

  yum_repository 'gocd' do
    description 'GoCD YUM Repository'
    baseurl yum_uri
    gpgcheck node['gocd']['repository']['yum']['gpgcheck']
    gpgkey node['gocd']['repository']['yum']['gpgkey']
  end
end
