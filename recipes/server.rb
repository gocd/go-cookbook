case node['platform']
when 'windows'
  include_recipe 'gocd::server_windows'
else
  include_recipe 'gocd::server_linux'
end

service(platform?('windows') ? 'Go Server' : 'go-server') do
  provider Chef::Provider::Service::Systemd if platform?('ubuntu') && node['platform_version'].to_f >= 16.04
  supports status: true, restart: true, start: true, stop: true
  action [:enable, :start]
  if node['gocd']['server']['wait_up']['retries'] != 0
    notifies :get, 'http_request[verify_go-server_comes_up]', :immediately
  end
end

http_request 'verify_go-server_comes_up' do
  url         "http://localhost:#{node['gocd']['server']['http_port']}/go/home"
  retry_delay node['gocd']['server']['wait_up']['retry_delay']
  retries     node['gocd']['server']['wait_up']['retries']
  action      :nothing
end

ruby_block 'publish_autoregister_key' do
  block do
    s = ::File.readlines(go_server_config_file).grep(/agentAutoRegisterKey="(\S+)"/)
    server_autoregister_key = unless s.empty?
                                s[0].to_s.match(/agentAutoRegisterKey="(\S+)"/)[1]
                              end
    Chef::Log.warn('Enabling automatic agent registration. Any configured agent will be configured to build without authorization.')
    node.set['gocd']['server']['autoregister_key'] = server_autoregister_key
    node.save
  end
  action :create
  not_if { Chef::Config[:solo] }
  retries 4
end
