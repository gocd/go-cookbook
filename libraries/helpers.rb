module Gocd
  module Helpers
    def get_agent_properties
      values = {}
      values[:go_server_port]   = node['gocd']['agent']['go_server_port']
      if Chef::Config['solo'] || node['gocd']['agent']['go_server_host']
        Chef::Log.info("Attempting to use node['gocd']['agent']['go_server_host'] attribute for server host")
        values[:go_server_host]   = node['gocd']['agent']['go_server_host']
        values[:key] = node['gocd']['agent']['autoregister']['key']
      else
        server_search_query = node['gocd']['agent']['server_search_query']
        Chef::Log.info("Search query: #{server_search_query}")
        go_servers = search(:node, server_search_query)
        if go_servers.count == 0
          Chef::Log.warn("No Go servers found on any of the nodes running chef client.")
        else
          go_server = go_servers.first
          values[:go_server_host] = go_server['ipaddress']
          if go_servers.count > 1
            Chef::Log.warn("Multiple Go servers found on Chef server. Using first returned server '#{values[:go_server_host]}' for server instance configuration.")
          end
          Chef::Log.info("Found Go server at ip address #{values[:go_server_host]} with automatic agent registration")
          if values[:key] = go_server['gocd']['server']['autoregister_key']
            Chef::Log.warn("Agent auto-registration enabled. This agent will not require approval to become active.")
          end
        end
      end
      values[:hostname]     = node['gocd']['agent']['autoregister']['hostname']
      values[:environments] = node['gocd']['agent']['autoregister']['environments']
      values[:resources]    = node['gocd']['agent']['autoregister']['resources']
      values[:daemon]       = node['gocd']['agent']['daemon']
      values[:vnc]          = node['gocd']['agent']['vnc']['enabled']
      values[:workspace]    = node['gocd']['agent']['workspace']
      values
    end

    def go_server_config_file
      if platform?('windows')
        'C:\Program Files\Go Server\config\cruise-config.xml'
      else
        '/etc/go/cruise-config.xml'
      end
    end
  end
end

Chef::Recipe.send(:include, ::Gocd::Helpers)
Chef::Resource.send(:include, ::Gocd::Helpers)
Chef::Provider.send(:include, ::Gocd::Helpers)
