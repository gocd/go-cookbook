require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'golang agent package' do
  it 'should be installed' do
    expect(file('/usr/bin/gocd-golang-agent')).to exist
  end
  it 'java agent should not be installed' do
    expect(package('go-agent')).to_not be_installed
  end
end

describe 'go agent service' do
  it 'process should be running' do
    expect(process('gocd-golang-agent')).to be_running
  end
end

describe '/etc/default/go-agent' do
  it 'should have the correct ownership and mode' do
    expect(file('/etc/default/go-agent')).to exist
    expect(file('/etc/default/go-agent')).to be_readable
    expect(file('/etc/default/go-agent')).to be_mode(644)
    expect(file('/etc/default/go-agent')).to be_owned_by('root')
    expect(file('/etc/default/go-agent')).to be_grouped_into('root')
  end
end
