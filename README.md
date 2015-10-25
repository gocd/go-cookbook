# GoCD Cookbook

This cookbook is here to help you setup Go servers and agents in an automated way.

## Supported Platforms

This cookbook has been tested on the following platforms:

* Ubuntu >= 12.04
* Debian
* CentOS >= 6
* RedHat >= 6
* Windows - primitive support, but enhancements welcome :)

### Java

Please note that java (>= 7) is needed to run Go server and agents. This cookbook
sets `node['java']['jdk_version']` at `force_default` level but it may not work properly
when you include `java` in node run_list before `gocd` cookbook. The safest approach
is to set java version in node attributes (in a role or environment).

## Install method

### Repository

By default installation source is done from apt or yum repositories from official sources at http://www.go.cd/download/.

The **apt** repository can be overriden by changing any these attributes:
```ruby
default['gocd']['repository']['apt']['uri'] = 'http://download.go.cd/gocd-deb/'
default['gocd']['repository']['apt']['components'] = [ '/' ]
default['gocd']['repository']['apt']['package_options'] = '--force-yes'
default['gocd']['repository']['apt']['keyserver'] = 'pgp.mit.edu'
default['gocd']['repository']['apt']['key'] = '0x9149B0A6173454C7'
```
The **yum** repository can be overriden by changing any these attributes:
```ruby
default['gocd']['repository']['yum']['baseurl'] = 'http://download.go.cd/gocd-rpm'
default['gocd']['repository']['yum']['gpgcheck'] = false
```

### From remote file

Cookbook can skip adding repository and install Go server or agent by downloading a remote file and install it directly via `dpkg` or `rpm`.

Change install method to 'package_file':
```ruby
node['gocd']['install_method'] = 'package_file'
```

And assign base url where packages are available for download
```ruby
node['gocd']['package_file']['baseurl'] = 'http://my/custom/url'
```
The final download URL of file is built based on platform and `node['gocd']['version']`. E.g. `http://my/custom/url/go-agent-15.2.0-2520.deb`


# GoCD Server

gocd::server will install and start a GoCD server.

## Go Server attributes

The cookbook provides the following attributes to configure the GoCD server:

* `node['gocd']['server']['http_port']`    - The server HTTP port. Defaults to `8153`.
* `node['gocd']['server']['https_port']`   - The server HTTPS port. Defaults to `8154`.
* `node['gocd']['server']['max_mem']`      - The server maximum JVM heap space. Defaults to `2048m`.
* `node['gocd']['server']['min_mem']`      - The server mimimum JVM heap space. Defaults to `1024m`.
* `node['gocd']['server']['max_perm_gen']` - The server maximum JVM permgen space. Defaults to `400m`.
* `node['gocd']['server']['work_dir']` - The server working directory. Defaults to `/var/lib/go-server`.

# GoCD Agent

gocd::agent will install and start a GoCD agent.
You can change the number of agents in `node['gocd']['agent']['count']` - first
agent is called `go-agent`, next ones are `go-agent-#`.

`gocd::agent` recipe uses GoCD agent LWRP internally.

## Go Agent attributes

The cookbook provides the following attributes to configure the GoCD agent:

* `node['gocd']['agent']['go_server_host']`               - The hostname of the go server (if left alone, will be autodetected). Defaults to `nil`.
* `node['gocd']['agent']['go_server_port']`               - The port of the go server. Defaults to `8153`.
* `node['gocd']['agent']['daemon']`                       - Whether the agent should be daemonized. Defaults to `true`.
* `node['gocd']['agent']['vnc']['enabled']`               - Whether the agent should start with VNC. (Uses `DISPLAY=:3`). Defaults to `false`.
* `node['gocd']['agent']['autoregister']['key']`          - The [agent autoregister](http://www.go.cd/documentation/user/current/advanced_usage/agent_auto_register.html) key. If left alone, will be autodetected. Defaults to `nil`.
* `node['gocd']['agent']['autoregister']['environments']` - The environments for the agent. Defaults to `[]`.
* `node['gocd']['agent']['autoregister']['resources']`    - The resources for the agent. Defaults to `[]`.
* `node['gocd']['agent']['autoregister']['hostname']`     - The agent autoregister hostname. Defaults to `node['fqdn']`.
* `node['gocd']['agent']['server_search_query']`          - The chef search query to find a server node. Defaults to `chef_environment:#{node.chef_environment} AND recipes:go-server\\:\\:default`.

# GoCD Agent LWRP

If agent recipe + attributes is not flexible enough or if you prefer chef resources
then you can add go-agent services with `gocd_agent` LWRP.

### Example agents

All resource attributes fall back to node attributes so agent can be defined
in just one line:

```ruby
gocd_agent 'my-agent'
```

It would create `my-agent` service and if all node values are correct then it
would also autoregister.

A custom agent may look like this:
```ruby
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
```

# License

Apache License, Version 2.0
