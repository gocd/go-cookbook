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

shared_examples_for :apt_repository_recipe do
  before do
    stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
  end
  it 'includes apt recipe' do
    expect(chef_run).to include_recipe('apt')
  end
  it 'adds gocd apt repository' do
    expect(chef_run).to add_apt_repository('gocd').with(
      uri: 'https://download.gocd.io',
      keyserver: 'pgp.mit.edu',
      key: 'https://download.gocd.io/GOCD-GPG-KEY.asc',
      components: ['/'])
  end
  it 'adds gocd experimental apt repository if experimental flag is turned on' do
    chef_run.node.set['gocd']['use_experimental'] = true
    chef_run.converge(described_recipe)
    expect(chef_run).to add_apt_repository('gocd').with(
      uri: 'https://download.gocd.io/experimental',
      keyserver: 'pgp.mit.edu',
      key: 'https://download.gocd.io/GOCD-GPG-KEY.asc',
      components: ['/'])
  end
end

shared_examples_for :yum_repository_recipe do
  before do
    stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
  end
  it 'includes yum recipe' do
    expect(chef_run).to include_recipe('yum')
  end
  it 'adds gocd yum repository' do
    expect(chef_run).to create_yum_repository('gocd').with(
      baseurl: 'https://download.gocd.io',
      description: 'GoCD YUM Repository',
      gpgcheck: true,
      gpgkey: 'https://download.gocd.io/GOCD-GPG-KEY.asc'
    )
  end
  it 'adds gocd experimental yum repository if experimental flag is turned on' do
    chef_run.node.set['gocd']['use_experimental'] = true
    chef_run.converge(described_recipe)
    expect(chef_run).to create_yum_repository('gocd').with(
      baseurl: 'https://download.gocd.io/experimental',
      description: 'GoCD YUM Repository',
      gpgcheck: true,
      gpgkey: 'https://download.gocd.io/GOCD-GPG-KEY.asc'
    )
  end
end

shared_examples_for :agent_linux_install do
  before do
    stub_command("grep -q '# Provides: go-agent$' /etc/init.d/go-agent").and_return(false)
  end

  it 'includes java recipe' do
    expect(chef_run).to include_recipe('java::default')
  end

  it 'includes gocd::agent_linux_install recipe' do
    expect(chef_run).to include_recipe('gocd::agent_linux_install')
  end
end
