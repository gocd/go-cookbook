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
