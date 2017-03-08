require 'open-uri'

module Gocd
  module Helpers
    def fetch_content url
      open(url, 'r').read
    end

    def get_agent_properties
      values = {}
      values[:go_server_url] = node['gocd']['agent']['go_server_url']
      if Chef::Config['solo'] || node['gocd']['agent']['go_server_url']
        Chef::Log.info("Attempting to use node['gocd']['agent']['go_server_url'] attribute for server url")
        values[:go_server_url] = node['gocd']['agent']['go_server_url']
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
          values[:go_server_ssl_port] = go_server['gocd']['server']['https_port']
          if go_servers.count > 1
            Chef::Log.warn("Multiple Go servers found on Chef server. Using first returned server '#{values[:go_server_host]}' for server instance configuration.")
          end
          Chef::Log.info("Found Go server at ip address #{values[:go_server_host]} with automatic agent registration")
          if values[:key] = go_server['gocd']['server']['autoregister_key']
            Chef::Log.warn("Agent auto-registration enabled. This agent will not require approval to become active.")
          end
          values[:go_server_url] = "https://#{values[:go_server_host]}:#{values[:go_server_ssl_port]}/go"
        end
      end
      values[:hostname]     = node['gocd']['agent']['autoregister']['hostname']
      values[:environments] = node['gocd']['agent']['autoregister']['environments']
      values[:resources]    = node['gocd']['agent']['autoregister']['resources']
      values[:elastic_agent_plugin_id]  = node['gocd']['agent']['elastic']['plugin_id']
      values[:elastic_agent_id]         = node['gocd']['agent']['elastic']['agent_id']
      values[:daemon]       = node['gocd']['agent']['daemon']
      values[:vnc]          = node['gocd']['agent']['vnc']['enabled']
      values[:workspace]    = node['gocd']['agent']['workspace']
      values
    end

    def go_server_config_file
      if platform?('windows')
        "#{node['gocd']['server']['work_dir']}\\config\\cruise-config.xml"
      else
        '/etc/go/cruise-config.xml'
      end
    end

    def latest_version?
      user_requested_version == 'latest'
    end

    def experimental?
      node['gocd']['use_experimental']
    end

    # version to pass into 'package' resource
    def user_requested_version
      # just return attribute value, when nil it will default to installing stable
      node['gocd']['version']
    end

    # Only needed when downloading package from URL
    def remote_version
      if latest_version? || user_requested_version.nil? || user_requested_version.empty?
        fetch_go_version(experimental?)
      else
        user_requested_version
      end
    end

    def updates_base_feed
      node['gocd']['updates']['baseurl']
    end

    def updates_url
      if node['gocd']['updates']['url']
        # user provided updates url
        node['gocd']['updates']['url']
      elsif node['gocd']['use_experimental']
        'https://update.gocd.io/channels/experimental/latest.json'
      else
        'https://update.gocd.io/channels/supported/latest.json'
      end
    end

    def fetch_go_version(_is_experimental)
      url = updates_url

      begin
        fetch_go_version_from_url url
      rescue => e
        Chef::Log.error("Failed to get Go version from updates service - #{e}")
        # fallback to last known stable
        '16.9.0-4001'
      end
    end

    def fetch_go_version_from_url url
      text = fetch_content url
      if text.empty?
        fail 'text is empty'
      end
      parsed = JSON.parse(text)
      fail 'Invalid format in version json file' unless parsed['message']
      message = JSON.parse(parsed['message'])
      return message['latest-version']
    end

    def package_extension
      value_for_platform_family('debian'        => '.deb',
                                %w(rhel fedora) => '.noarch.rpm',
                                'windows'       => '-setup.exe',
                                'default'       => '.zip')
    end

    def os_dir
      value_for_platform_family('debian'        => 'deb',
                                %w(rhel fedora) => 'rpm',
                                'windows'       => 'win',
                                'default'       => 'generic')
    end

    def go_agent_remote_package_name
      "go-agent-#{remote_version}#{package_extension}"
    end

    def go_server_remote_package_name
      "go-server-#{remote_version}#{package_extension}"
    end

    def user_friendly_version(component)
      if node['gocd']['version']
        return node['gocd']['version']
      elsif node['gocd'][component]['package_file']['url']
        return 'custom'
      elsif experimental?
        return 'experimental'
      else
        return 'stable'
      end
    end

    # user-friendly file names to use when downloading remote file
    def go_agent_package_name
      "go-agent-#{user_friendly_version('agent')}#{package_extension}"
    end

    def go_server_package_name
      "go-server-#{user_friendly_version('server')}#{package_extension}"
    end

    def yum_uri
      if node['gocd']['repository']['yum']['baseurl']
        # user provided yum URI
        node['gocd']['repository']['yum']['baseurl']
      elsif node['gocd']['use_experimental']
        'https://download.gocd.io/experimental'
      else
        'https://download.gocd.io'
      end
    end

    def apt_uri
      if node['gocd']['repository']['apt']['uri']
        # user provided apt URI
        node['gocd']['repository']['apt']['uri']
      elsif node['gocd']['use_experimental']
        'https://download.gocd.io/experimental'
      else
        'https://download.gocd.io'
      end
    end

    def go_baseurl
      if node['gocd']['package_file']['baseurl']
        # user specifed url to download packages from
        node['gocd']['package_file']['baseurl']
      else
        # use official source
        "https://download.gocd.io/binaries"
      end
    end

    def go_agent_package_url
      if node['gocd']['agent']['package_file']['url']
        # user specifed explictly the URL to download from
        node['gocd']['agent']['package_file']['url']
      else
        "#{go_baseurl}/#{remote_version}/#{os_dir}/#{go_agent_remote_package_name}"
      end
    end
    def go_server_package_url
      if node['gocd']['server']['package_file']['url']
        # user specifed explictly the URL to download from
        node['gocd']['server']['package_file']['url']
      else
        "#{go_baseurl}/#{remote_version}/#{os_dir}/#{go_server_remote_package_name}"
      end
    end

    def arch
      node['kernel']['machine'] =~ /x86_64/ ? 'amd64' : node['kernel']['machine']
    end
    def os
      node['os']
    end
  end
end

Chef::Recipe.send(:include, ::Gocd::Helpers)
Chef::Resource.send(:include, ::Gocd::Helpers)
Chef::Provider.send(:include, ::Gocd::Helpers)
