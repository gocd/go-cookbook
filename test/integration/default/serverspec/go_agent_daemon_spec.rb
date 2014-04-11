require 'serverspec'

include Serverspec::Helper::Exec

describe "Go Agent Daemon" do

  it "has a running service of go-agent" do
    expect(service("go-agent")).to be_running
  end

end