
server_ip = node['gocd']['agent']['server_host']
install_path = node['gocd']['agent']['install_path']

opts = ""
opts << "/SERVERIP=#{server_ip} " if node['gocd']['agent']['server_host']
opts << "/D=#{install_path}" if node['gocd']['agent']['install_path']

download_url =  if node['gocd']['agent'].key?('download_url')
                  node['gocd']['agent']['download_url']
                else
                  "http://download.go.cd/gocd/go-agent-#{node['gocd']['version']}-setup.exe"
                end

windows_package 'Go Agent' do
  source download_url
  options opts
  action :install
end
