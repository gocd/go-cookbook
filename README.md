# GoCD Cookbook

This cookbook is here to help you setup Go servers and agents in an automated way.

## Supported Platforms

This cookbook has been tested on the following platforms:

* Ubuntu >= 12.04
* Debian
* CentOS >= 6
* RedHat >= 6
* Windows - no support yet, but PRs welcome :)

## 1.0 release notes

This cookbook has gone major rewrite and has little to do with pre-`1.0` versions.
If you have been using go-cookbook previously then please note that:

 * cookbook has been renamed to `gocd`, just like root namespace of attributes.
 * Windows support in on best-effort basis

### Java

Please note that java 8 is recommended to run Go server and agents. This cookbook
sets `node['java']['jdk_version']` at `force_default` level but it may not work properly
when you include `java` in node run_list before `gocd` cookbook. The safest approach
is to set java version in node attributes (in a role or environment).

## Install method

### Repository

By default installation source is done from apt or yum repositories from official sources at https://www.gocd.io/download/.

The **apt** repository can be overriden by changing any these attributes:

 * `node['gocd']['repository']['apt']['uri'] = 'https://download.gocd.io/'`
 * `node['gocd']['repository']['apt']['components'] = [ '/' ]`
 * `node['gocd']['repository']['apt']['distribution'] = ''`
 * `node['gocd']['repository']['apt']['keyserver'] = 'pgp.mit.edu'`
 * `node['gocd']['repository']['apt']['key'] = 'https://download.gocd.io/GOCD-GPG-KEY.asc'`

The **yum** repository can be overriden by changing any these attributes:

 * `node['gocd']['repository']['yum']['baseurl'] = 'https://download.gocd.io'`
 * `node['gocd']['repository']['yum']['gpgcheck'] = true`
 * `node['gocd']['repository']['yum']['gpgkey'] = 'https://download.gocd.io/GOCD-GPG-KEY.asc'`

#### Experimental channel

By default Go cookbook installs latest stable version.
You can install gocd from experimental channel by setting

```
node['gocd']['use_experimental'] = true
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

The final download URL of file is built based on platform and `node['gocd']['version']`.
E.g. `http://my/custom/url/go-agent-15.2.0-2520.deb`

# GoCD Server

gocd::server will install and start a GoCD server.

## Go Server attributes

The cookbook provides the following attributes to configure the GoCD server:

* `node['gocd']['server']['http_port']`    - The server HTTP port. Defaults to `8153`.
* `node['gocd']['server']['https_port']`   - The server HTTPS port. Defaults to `8154`.
* `node['gocd']['server']['max_mem']`      - The server maximum JVM heap space. Defaults to `2048m`.
* `node['gocd']['server']['min_mem']`      - The server mimimum JVM heap space. Defaults to `1024m`.
* `node['gocd']['server']['max_perm_gen']` - The server maximum JVM permgen space. Defaults to `400m`.
* `node['gocd']['server']['work_dir']`     - The server working directory. Defaults to `/var/lib/go-server` on linux, `C:\GoServer` on Windows.

Chef cookbook waits for server to become responsive after restarting service.
These attributes can be used to tune it:

* `node['gocd']['server']['wait_up']['retry_delay']` - pause in seconds between failed attempts.
* `node['gocd']['server']['wait_up']['retries']`     - number of attempts before giving up. Set 0 to disable waiting at all. Defaults to 10

# GoCD Agent

`gocd::agent` will install and start a GoCD agent.
You can change the number of agents in `node['gocd']['agent']['count']` - first
agent is called `go-agent`, next ones are `go-agent-#`.

`gocd::agent` recipe uses GoCD agent LWRP internally.

## Go Agent attributes

The cookbook provides the following attributes to configure the GoCD agent:

* `node['gocd']['agent']['go_server_url']`                - URL of Go server that agent should connect to. It must start with `https://` and end with `/go`. For example `https://localhost:8154/go`.
* `node['gocd']['agent']['daemon']`                       - Whether the agent should be daemonized. Defaults to `true`.
* `node['gocd']['agent']['vnc']['enabled']`               - Whether the agent should start with VNC. (Uses `DISPLAY=:3`). Defaults to `false`.
* `node['gocd']['agent']['autoregister']['key']`          - The [agent autoregister](https://docs.gocd.io/current/advanced_usage/agent_auto_register.html) key. If left alone, will be auto-detected. Defaults to `nil`.
* `node['gocd']['agent']['autoregister']['environments']` - The environments for the agent. Defaults to `[]`.
* `node['gocd']['agent']['autoregister']['resources']`    - The resources for the agent. Defaults to `[]`.
* `node['gocd']['agent']['autoregister']['hostname']`     - The agent autoregister hostname. Defaults to `node['fqdn']`.
* `node['gocd']['agent']['server_search_query']`          - The chef search query to find a server node. Defaults to `chef_environment:#{node.chef_environment} AND recipes:gocd\\:\\:server`.

### Beta

Attributes for elastic agents:

* `node['gocd']['agent']['elastic']['plugin_id']`
* `node['gocd']['agent']['elastic']['agent_id']`

#### Golang agent support

By default `node['gocd']['agent']['type']` is set to `java`. Set it to `golang`
to install [GoCD agent written in Go](https://github.com/gocd-contrib/gocd-golang-agent).
Note that this agent has quite a few limitations.

### Depreciated

Please use `node['gocd']['agent']['go_server_url']` instead of:

* `node['gocd']['agent']['go_server_host']` - The hostname of the go server (if left alone, will be auto-detected). Defaults to `nil`.
* `node['gocd']['agent']['go_server_port']` - The port of the go server. Defaults to `8153`.

# GoCD Agent LWRP (currently only works on linux)

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

# GoCD autoregister file resource

If you want to setup agents *your-way* then this resource is helpful to **only**
generate a valid `autoregister.properties` file:

Example use:
```ruby
gocd_agent_autoregister_file '/var/mygo/autoregister.properties' do
  autoregister_key 'bla-key'
  autoregister_hostname 'mygo-agent'
  environments 'stage'
  resources     ['java-8','ruby']
end
```

Can be used to prepare elastic agents too:
```ruby
gocd_agent_autoregister_file '/var/elastic/autoregister.properties' do
  autoregister_key 'some-key'
  autoregister_hostname 'elastic-agent'
  environments 'testing'
  resources     ['java-8']
  elastic_agent_id 'agent-id'
  elastic_agent_plugin_id 'elastic-agent-plugin-id'
end
```

# GoCD plugin LWRP

You can install Go server plugins with `gocd_plugin` LWRP like this

```ruby
include_recipe 'gocd::server'

gocd_plugin 'github-pr-status' do
  plugin_uri 'https://github.com/gocd-contrib/gocd-build-status-notifier/releases/download/1.1/github-pr-status-1.1.jar'
end
```

# Server Specification

When using the cookbook please refer to the [server specification section](https://docs.gocd.io/current/installation/system_requirements.html) of the GoCD documentation.

# License

Apache License, Version 2.0
