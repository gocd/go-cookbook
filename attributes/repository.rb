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

default['gocd']['version'] = nil # can be `latest` or specify a version `X.Y.Z-ABCD`
default['gocd']['use_experimental'] = false

default['gocd']['install_method'] = if node['platform_family'] == 'windows'
                                      'package_file'
                                    else
                                      'repository'
                                    end

default['gocd']['updates']['url'] = nil

default['gocd']['repository']['apt']['components'] = ['/']
default['gocd']['repository']['apt']['distribution'] = ''
default['gocd']['repository']['apt']['keyserver'] = 'pgp.mit.edu'
default['gocd']['repository']['apt']['key'] = 'https://download.gocd.org/GOCD-GPG-KEY.asc'

default['gocd']['repository']['yum']['gpgcheck'] = true
default['gocd']['repository']['yum']['gpgkey'] = 'https://download.gocd.org/GOCD-GPG-KEY.asc'

default['gocd']['package_file']['baseurl'] = nil # official - "https://download.gocd.org/binaries"
default['gocd']['agent']['package_file']['url'] = nil # official
default['gocd']['server']['package_file']['url'] = nil # official
