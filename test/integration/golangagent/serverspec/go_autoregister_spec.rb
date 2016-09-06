require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'go server agents tab' do
  describe command('curl -L localhost:8153/go') do
      its(:stdout) { should contain('/go/home') }
  end
  describe command('curl -L http://localhost:8153/go/agents') do
    its(:stdout) { should contain('/var/lib/go-agent') }
    its(:stdout) { should contain('Idle') }
  end
end
