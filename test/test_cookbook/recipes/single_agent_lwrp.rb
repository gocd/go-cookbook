gocd_agent 'my-go-agent' do
  go_server_host 'go.example.com'
  go_server_port 80
  daemon true
  vnc    true
  autoregister_key 'bla-key'
  autoregister_hostname 'my-lwrp-agent'
  environments 'production'
  resources     ['java-8','ruby-2.2']
  workspace     '/mnt/big_drive'
end
