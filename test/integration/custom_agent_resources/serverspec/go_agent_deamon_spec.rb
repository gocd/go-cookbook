require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "Go Agent Daemon" do

  it "has a running service of go-agent" do
    expect(service("go-agent")).to be_running
  end
end

describe "GO Agent Config" do 
  describe file('/var/lib/go-agent/config/autoregister.properties') do 
  	it {should be_file}
  	it {should be_readable}
  	it { should contain 'agent.auto.register.key=default_auto_registration_key' }
  	it { should contain 'agent.auto.register.resources=a,b,c,linux,ubuntu,ubuntu-' }
  	it { should contain 'agent.auto.register.environments=x,y,z' }
  end

end
