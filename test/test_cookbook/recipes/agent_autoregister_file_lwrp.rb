gocd_agent_autoregister_file '/var/mygo/autoregister.properties' do
  autoregister_key 'bla-key'
  autoregister_hostname 'mygo-agent'
  environments 'stage'
  resources ['java-8', 'ruby']
end

gocd_agent_autoregister_file '/var/elastic/autoregister.properties' do
  autoregister_key 'some-key'
  autoregister_hostname 'elastic-agent'
  environments 'testing'
  resources ['java-8']
  elastic_agent_id 'agent-id'
  elastic_agent_plugin_id 'elastic-agent-plugin-id'
end

gocd_agent_autoregister_file '/var/attrs/autoregister.properties'
