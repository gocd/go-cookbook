gocd_agent 'my-go-agent' do
  go_server_url 'https://go.example.com:443/go'
  daemon true
  vnc    true
  autoregister_key 'bla-key'
  autoregister_hostname 'my-lwrp-agent'
  environments 'production'
  resources     ['java-8', 'ruby-2.2']
  workspace     '/mnt/big_drive'
end
