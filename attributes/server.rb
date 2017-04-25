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

default['gocd']['server']['http_port']    = 8153
default['gocd']['server']['https_port']   = 8154
default['gocd']['server']['max_mem']      = '2048m'
default['gocd']['server']['min_mem']      = '1024m'
default['gocd']['server']['max_perm_gen'] = '400m'
default['gocd']['server']['work_dir']     = '/var/lib/go-server'

default['gocd']['server']['work_dir'] = 'C:\GoServer' if platform?('windows')

default['gocd']['server']['wait_up']['retry_delay'] = 10
default['gocd']['server']['wait_up']['retries']     = 10
default['gocd']['server']['default_extras']         = {}
