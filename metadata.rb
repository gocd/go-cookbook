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

name             'gocd'
description      'Installs/Configures Go servers and agents'
maintainer       'GoCD Contributors'
maintainer_email 'go-cd@googlegroups.com'
version          '3.0.1'
source_url       'https://github.com/gocd/go-cookbook' if respond_to?(:source_url)
issues_url       'https://github.com/gocd/go-cookbook/issues' if respond_to?(:issues_url)
chef_version     '>= 12'
license          'Apache-2.0'

supports 'ubuntu'
supports 'centos'
supports 'redhat'
supports 'windows'

recipe 'gocd::server', 'Installs and configures a Go server'
recipe 'gocd::agent', 'Installs and configures a Go agent'
recipe 'gocd::repository', 'Installs the go yum/apt repository'
recipe 'gocd::agent_windows', 'Installs and configures Windows Go agent'
recipe 'gocd::server_windows', 'Installs and configures Windows Go server'
recipe 'gocd::agent_linux', 'Install and configures Linux Go agent'
recipe 'gocd::server_linux', 'Install and configures Linux Go server'

depends 'apt', '>= 3.0.0'
depends 'java'
depends 'yum'
depends 'windows'
