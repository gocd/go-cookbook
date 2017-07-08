##########################################################################
# Copyright 2017 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

require 'open-uri'

module Gocd
  module Helpers
    def fetch_content(url)
      open(url, 'r').read
    end

    def agent_properties
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
          Chef::Log.warn('No Go servers found on any of the nodes running chef client.')
        else
          go_server = go_servers.first
          values[:go_server_host] = go_server['ipaddress']
          values[:go_server_ssl_port] = go_server['gocd']['server']['https_port']
          if go_servers.count > 1
            Chef::Log.warn("Multiple Go servers found on Chef server. Using first returned server '#{values[:go_server_host]}' for server instance configuration.")
          end
          Chef::Log.info("Found Go server at ip address #{values[:go_server_host]} with automatic agent registration")
          if values[:key] == go_server['gocd']['server']['autoregister_key']
            Chef::Log.warn('Agent auto-registration enabled. This agent will not require approval to become active.')
          end
          values[:go_server_url] = "https://#{values[:go_server_host]}:#{values[:go_server_ssl_port]}/go"
        end
      end
      values[:hostname] = node['gocd']['agent']['autoregister']['hostname']
      values[:environments] = node['gocd']['agent']['autoregister']['environments']
      values[:resources] = node['gocd']['agent']['autoregister']['resources']
      values[:elastic_agent_plugin_id] = node['gocd']['agent']['elastic']['plugin_id']
      values[:elastic_agent_id] = node['gocd']['agent']['elastic']['agent_id']
      values[:daemon] = node['gocd']['agent']['daemon']
      values[:vnc] = node['gocd']['agent']['vnc']['enabled']
      values[:workspace] = node['gocd']['agent']['workspace']
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
        'https://update.gocd.org/channels/experimental/latest.json'
      else
        'https://update.gocd.org/channels/supported/latest.json'
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

    def fetch_go_version_from_url(url)
      text = fetch_content url
      raise 'text is empty' if text.empty?
      parsed = JSON.parse(text)
      raise 'Invalid format in version json file' unless parsed['message']
      message = JSON.parse(parsed['message'])
      message['latest-version']
    end

    def package_extension
      value_for_platform_family('debian' => '.deb',
                                %w(rhel fedora) => '.noarch.rpm',
                                'windows' => '-setup.exe',
                                'default' => '.zip')
    end

    def os_dir
      value_for_platform_family('debian' => 'deb',
                                %w(rhel fedora) => 'rpm',
                                'windows' => 'win',
                                'default' => 'generic')
    end

    def go_agent_remote_package_name
      if os_dir == 'deb'
        "go-agent_#{remote_version}_all#{package_extension}"
      elsif os_dir == 'win'
        case node['kernel']['os_info']['os_architecture']
        when '32-bit'
          "go-agent-#{remote_version}-jre-32bit#{package_extension}"
        else
          "go-agent-#{remote_version}-jre-64bit#{package_extension}"
        end
      else
        "go-agent-#{remote_version}#{package_extension}"
      end
    end

    def go_server_remote_package_name
      if os_dir == 'deb'
        "go-server_#{remote_version}_all#{package_extension}"
      elsif os_dir == 'win'
        case node['kernel']['os_info']['os_architecture']
        when '32-bit'
          "go-server-#{remote_version}-jre-32bit#{package_extension}"
        else
          "go-server-#{remote_version}-jre-64bit#{package_extension}"
        end
      else
        "go-server-#{remote_version}#{package_extension}"
      end
    end

    def user_friendly_version(component)
      if node['gocd']['version']
        node['gocd']['version']
      elsif node['gocd'][component]['package_file']['url']
        'custom'
      elsif experimental?
        'experimental'
      else
        'stable'
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
        'https://download.gocd.org/experimental'
      else
        'https://download.gocd.org'
      end
    end

    def apt_uri
      if node['gocd']['repository']['apt']['uri']
        # user provided apt URI
        node['gocd']['repository']['apt']['uri']
      elsif node['gocd']['use_experimental']
        'https://download.gocd.org/experimental'
      else
        'https://download.gocd.org'
      end
    end

    def go_baseurl
      if node['gocd']['package_file']['baseurl']
        # user specifed url to download packages from
        node['gocd']['package_file']['baseurl']
      else
        # use official source
        'https://download.gocd.org/binaries'
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
