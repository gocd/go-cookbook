require 'uri'

include_recipe 'windows'

require 'win32/service'

include_recipe 'java'

install_path = node['go']['server']['install_path']
opts = "/S /D=#{install_path}"

download_url = node['go']['server']['download_url']
if !download_url
  download_url = "http://download.go.cd/gocd/go-server-#{node['go']['version']}-setup.exe"
end

windows_package 'Go Server' do
  source download_url
  action :install
end

registry_key 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' do
  values [{:name => 'CRUISE_SERVER_DIR', :type => :string, :data => install_path },
          {:name => 'GO_SERVER_JAVA_HOME', :type => :string, :data => "#{install_path}\\jre" }
         ]
end

windows_batch "cruisewrapper" do
  code "\"#{install_path}\\cruisewrapper.exe\" --install \"#{install_path}\\config\\wrapper-server.conf\""
  not_if { ::Win32::Service.exists? 'Go Server' }
end

windows_batch "open firewall" do
  code 'netsh advfirewall firewall add rule name="Go Server" dir=in action=allow protocol=TCP localport=8153'
end

service "Go server" do
  action :start
end
