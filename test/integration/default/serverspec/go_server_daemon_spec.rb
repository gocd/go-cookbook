require 'serverspec'

include Serverspec::Helper::Exec

describe "Go Server Daemon" do

  # it "is listening on port 8153" do
  #   expect(port(8153)).to be_listening
  # end

  it "has a running service of go-server" do
    expect(service("go-server")).to be_running
  end

end