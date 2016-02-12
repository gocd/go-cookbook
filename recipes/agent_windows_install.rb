remote_file node['gocd']['agent']['package_file']['filename'] do
  path node['gocd']['agent']['package_file']['path']
  source node['gocd']['agent']['package_file']['url']
end

autoregister_values = get_agent_properties

if autoregister_values[:go_server_host].nil?
  autoregister_values[:go_server_host] = '127.0.0.1'
  Chef::Log.warn("Go server not found on Chef server or not specifed via node['gocd']['agent']['go_server_host'] attribute, defaulting Go server to #{autoregister_values[:go_server_host]}")
end

opts = []
opts << "/SERVERIP=#{autoregister_values[:go_server_host]}"
opts << '/D=C:\GoAgent'

if defined?(Chef::Provider::Package::Windows)
  package 'Go Agent' do
    source node['gocd']['agent']['package_file']['path']
    options opts.join(" ")
  end
else
  windows_package 'Go Agent' do
    source node['gocd']['agent']['package_file']['path']
    options opts.join(" ")
  end
end
