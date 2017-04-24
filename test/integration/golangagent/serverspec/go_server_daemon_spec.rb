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

describe 'go server package' do
  it 'should be installed' do
    expect(package('go-server')).to be_installed
  end
end

describe 'go server service' do
  it 'should be running' do
    expect(service('go-server')).to be_running
    expect(service('go-server')).to be_enabled
  end

  it 'should be listening on port 8153' do
    expect(port(8153)).to be_listening
  end

  it 'should be listening on port 8154' do
    expect(port(8154)).to be_listening
  end
end

describe '/etc/default/go-server' do
  it 'should have the correct ownership and mode' do
    expect(file('/etc/default/go-server')).to exist
    expect(file('/etc/default/go-server')).to be_readable
    expect(file('/etc/default/go-server')).to be_mode(644)
    expect(file('/etc/default/go-server')).to be_owned_by('root')
    expect(file('/etc/default/go-server')).to be_grouped_into('root')
  end
end
