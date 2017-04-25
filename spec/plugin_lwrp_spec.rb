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

require 'spec_helper'

describe 'gocd_test::plugin_lwrp' do
  let(:chef_run) do
    run = ChefSpec::SoloRunner.new(step_into: 'gocd_plugin') do |node|
      node.automatic['lsb']['id'] = 'Debian'
      node.automatic['platform_family'] = 'debian'
      node.automatic['platform'] = 'debian'
      node.automatic['os'] = 'linux'
    end
    run.converge(described_recipe)
  end

  it 'creates gocd_plugin chef resource' do
    expect(chef_run).to create_gocd_plugin('github-pr-status')
  end
  it 'downloads github-pr-status plugin as a remote_file' do
    expect(chef_run).to create_remote_file('/var/lib/go-server/plugins/external/github-pr-status.jar')
      .with(
        source: 'https://github.com/gocd-contrib/gocd-build-status-notifier/releases/download/1.1/github-pr-status-1.1.jar',
        owner: 'go'
      )
  end
end
