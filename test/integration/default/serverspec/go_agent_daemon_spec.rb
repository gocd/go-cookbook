require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'go agent package' do
  it 'should be installed' do
    expect(package('go-agent')).to be_installed
  end
end

describe 'go agent service' do
  it 'should be running' do
    expect(service('go-agent')).to be_running
    expect(service('go-agent')).to be_enabled
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
