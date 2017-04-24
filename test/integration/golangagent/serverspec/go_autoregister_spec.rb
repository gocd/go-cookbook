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

require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'go server agents tab' do
  describe command('curl -L localhost:8153/go') do
    its(:stdout) { should contain('/go/home') }
  end
  describe command('curl -H \'Accept: application/vnd.go.cd.v4+json\' localhost:8153/go/api/agents') do
    its(:stdout) { should contain('/var/lib/go-agent') }
    its(:stdout) { should contain('Idle') }
  end
end
