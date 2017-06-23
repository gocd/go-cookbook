# GoCD Cookbook

This cookbook is here to help you setup GoCD servers and agents in an automated way.

## Scope

* This cookbook can be used for installing and configuring a GoCD server and multiple GoCD agents.
* On linux machines, the recipes used for installing the GoCD server and agents use the yum and apt repositories to install from. Zip installations are not supported.

## Requirements

* chef >= 12.6

### Certain resource properties are broken in Chef 13. Check the deprecations in the [changelog](https://github.com/gocd/go-cookbook/blob/master/CHANGELOG.md) for more details.

## Dependencies

* apt
* java
* yum
* windows (requires chef >= 12.6; for chef < 12.6 please use these additional dependency version constraints for compatibility with Chef 11: `cookbook 'windows', '< 2.0'`)

## Supported Platforms

This cookbook has been tested on the following platforms:

* Ubuntu >= 12.04
* Debian
* CentOS >= 6
* RedHat >= 6
* Windows - no support yet, but PRs welcome :)

## Usage

1. Add this cookbook to your Chef Server, either by installing with knife or by adding it to your Berksfile:  `cookbook 'gocd', '~>1.3.2'`

2. Change the default configuration [attributes](# Go Server attributes) by overriding the node attributes:
  * via a role, or
  * by declaring it in another cookbook at a higher precedence levels

3. Run the recipes on the specific nodes as:
  * `chef-client --runlist 'recipe[gocd]'` - This will install the GoCD server and agent on the same machine
  * `chef-client --runlist 'recipe[gocd::server]'` - This will install the GoCD server with specified configuration
  * `chef-client --runlist 'recipe[gocd::agent]'` - This will install the GoCD agent with specified configuration.

  OR

  Associate the recipes with the desired roles. Here's an example role with default recipes:
```
  name 'demo'
  description 'Sample role for using the go-cookbook'

  default_attributes(
    'gocd' => {
      'version' => '17.3.0-4669',
      'use_experimental' => true
    }
  )

  run_list %w(
    recipe[gocd]
  )
```

## 1.0 release notes

This cookbook has undergone a major rewrite and has little to do with pre-`1.0` versions.
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

By default installation source is done from apt or yum repositories from official sources at https://www.gocd.org/download/.

The **apt** repository can be overridden by changing any these attributes:

 * `node['gocd']['repository']['apt']['uri'] = 'https://download.gocd.org/'`
 * `node['gocd']['repository']['apt']['components'] = [ '/' ]`
 * `node['gocd']['repository']['apt']['distribution'] = ''`
 * `node['gocd']['repository']['apt']['keyserver'] = 'pgp.mit.edu'`
 * `node['gocd']['repository']['apt']['key'] = 'https://download.gocd.org/GOCD-GPG-KEY.asc'`

The **yum** repository can be overridden by changing any these attributes:

 * `node['gocd']['repository']['yum']['baseurl'] = 'https://download.gocd.org'`
 * `node['gocd']['repository']['yum']['gpgcheck'] = true`
 * `node['gocd']['repository']['yum']['gpgkey'] = 'https://download.gocd.org/GOCD-GPG-KEY.asc'`

#### Experimental channel

By default the GoCD cookbook installs latest stable version.
You can install gocd from the experimental channel by setting the `node['gocd']['use_experimental']` attribute to `true`

### From remote file

The cookbook can skip adding a package repository and instead install a GoCD server or agent by downloading a remote file and installing it directly via `dpkg` or `rpm`. To use this method, set `node['gocd']['install_method']` to `'package_file'` and set `node['gocd']['package_file']['baseurl']` to point to the remote file (e.g. `'http://my/custom/url'`)

The final download URL of file is built based on platform and `node['gocd']['version']` (e.g. using the example baseurl above, `http://my/custom/url/go-agent-15.2.0-2520.deb`)

# GoCD Server

`gocd::server` will install and start a GoCD server.

## Go Server attributes

The cookbook provides the following attributes to configure the GoCD server:

* `node['gocd']['server']['http_port']`    - The server HTTP port. Defaults to `8153`.
* `node['gocd']['server']['https_port']`   - The server HTTPS port. Defaults to `8154`.
* `node['gocd']['server']['max_mem']`      - The server maximum JVM heap space. Defaults to `2048m`.
* `node['gocd']['server']['min_mem']`      - The server mimimum JVM heap space. Defaults to `1024m`.
* `node['gocd']['server']['max_perm_gen']` - The server maximum JVM permgen space. Defaults to `400m`.
* `node['gocd']['server']['work_dir']`     - The server working directory. Defaults to `/var/lib/go-server` on linux, `C:\GoServer` on Windows.

Chef cookbook waits for the server to become responsive after restarting
the service. These attributes can be used to tune it:

* `node['gocd']['server']['wait_up']['retry_delay']` - pause in seconds between failed attempts.
* `node['gocd']['server']['wait_up']['retries']`     - number of attempts before giving up. Set 0 to disable waiting at all. Defaults to 10

# GoCD Agent

`gocd::agent` will install and start a GoCD agent. You can change the number of agents in `node['gocd']['agent']['count']`. The first
agent is called `go-agent`, next ones are `go-agent-#`.

`gocd::agent` recipe uses the GoCD agent LWRP internally.

## Go Agent attributes

The cookbook provides the following attributes to configure the GoCD agent:

* `node['gocd']['agent']['go_server_url']`                - URL of Go server that agent should connect to. It must start with `https://` and end with `/go`. For example `https://localhost:8154/go`.
* `node['gocd']['agent']['daemon']`                       - Whether the agent should be daemonized. Defaults to `true`.
* `node['gocd']['agent']['vnc']['enabled']`               - Whether the agent should start with VNC. (Uses `DISPLAY=:3`). Defaults to `false`.
* `node['gocd']['agent']['autoregister']['key']`          - The [agent autoregister](https://docs.gocd.org/current/advanced_usage/agent_auto_register.html) key. If left alone, will be auto-detected. Defaults to `nil`.
* `node['gocd']['agent']['autoregister']['environments']` - The environments for the agent. Defaults to `[]`.
* `node['gocd']['agent']['autoregister']['resources']`    - The resources for the agent. Defaults to `[]`.
* `node['gocd']['agent']['autoregister']['hostname']`     - The agent autoregister hostname. Defaults to `node['fqdn']`.
* `node['gocd']['agent']['server_search_query']`          - The chef search query to find a server node. Defaults to `chef_environment:#{node.chef_environment} AND recipes:gocd\\:\\:server`.

## Custom Resources

1. `gocd_agent`
  * Actions:
    - `:create`
    - `:delete`

  * Attributes:

| Attribute Name            |    Default    | Description                                                                                                                                                                                                                                                                                                           |
|:--------------------------|:-------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| agent_name                |    create     | Name of the resource to be created or deleted.                                                                                                                                                                                                                                                                        |
| service_action            | enable, start | The GoCD agent service supports `:status`, `:enable`, `:start`, `:restart`, `:stop`                                                                                                                                                                                                                                   |
| user                      |      go       | The user that can start and configure the GoCD agents.                                                                                                                                                                                                                                                                |
| group                     |      go       | The group of users that can configure the GoCD agents.                                                                                                                                                                                                                                                                |
| go_server_url             |      nil      | The url of the GoCD server that the agent has to connect to. It should begin with `https`, should connect to the `GO_SERVER_SSL_PORT`, and end with `/go`. If this isn't set, then the go server ip is detected (provided go server is also installed using chef). The fallback option is `https://localhost:8154/go` |
| daemon                    |     true      | Whether to start the GoCD agent as a daemon process.                                                                                                                                                                                                                                                                  |
| autoregister_key          |      nil      | The autoregister key can be used to directly register the agent with the GoCD server without manual intervention.                                                                                                                                                                                                     |
| autoregister_hostname     |      nil      | The name by which the agent will be known to the GoCD server                                                                                                                                                                                                                                                          |
| autoregister_environments |      nil      | The GoCD environments to which the agent must belong to.                                                                                                                                                                                                                                                              |
| environments              |      nil      | The GoCD environments to which the agent must belong to. This is DEPRECATED.                                                                                                                                                                                                                                          |
| autoregister_resources    |      nil      | The resources available on the gocd agent node which can be used with specific pipeline(s).                                                                                                                                                                                                                           |
| resources                 |      nil      | The resources available on the gocd agent node which can be used with specific pipeline(s). This is DEPRECATED.                                                                                                                                                                                                       |
| elastic_agent_id          |      nil      | The elastic agent id used to set the autoregister property `agent.auto.register.elasticAgent.agentId`.                                                                                                                                                                                                                |
| elastic_agent_plugin_id   |      nil      | The elastic agent plugin id.  This is used to set the autoregister property `agent.auto.register.elasticAgent.pluginId`                                                                                                                                                                                               |

*Note:* All of the above attributes are optional.

2.  `gocd_agent_autoregister_file`

This resource will create a file called `autoregister.properties` in the gocd agent's config directory. This is done so that the agent can directly register with the gocd server without manual intervention.

  * Actions
    - `:create`
    - `:delete`

  * Attributes

| Attribute Name            | Default | Description                                                                                                                         |
|:--------------------------|:-------:|:------------------------------------------------------------------------------------------------------------------------------------|
| owner                     |   go    | owner of the autoregister.properties file                                                                                           |
| group                     |   go    | group for the autoregister.properties file                                                                                          |
| autoregister_key          |   nil   | The autogregister key from the go server config that can be used to register the agent                                              |
| autoregister_hostname     |   nil   | The name by which the agent will be known to the GoCD server                                                                        |
| autoregister_environments |   nil   | The GoCD environments to which the agent must belong to.                                                                            |
| environments              |   nil   | The GoCD environments to which the agent must belong to. This is DEPRECATED.                                                        |
| autoregister_resources    |   nil   | The resources available on the gocd agent node which can be used with specific pipeline(s).                                         |
| resources                 |   nil   | The resources available on the gocd agent node which can be used with specific pipeline(s). This is DEPRECATED.                     |
| elastic_agent_id          |   nil   | The elastic agent id used to set the autoregister property `agent.auto.register.elasticAgent.agentId`.                              |
| elastic_agent_plugin_id   |   nil   | The elastic agent plugin id.  This is used to set the autoregister property `agent.auto.register.elasticAgent.pluginId`             |

3. `gocd_plugin`

| Attribute Name  |       Default        | Required | Description                                                                           |
|:----------------|:--------------------:|:--------:|:--------------------------------------------------------------------------------------|
| plugin_name     |         nil          |   true   | Name of the plugin                                                                    |
| plugin_uri      |         nil          |   true   | Location of the plugin jar on the workstation.                                        |
| server_work_dir | `/var/lib/go-server` |  false   | The working directory of the go server to where the plguin jar needs to be copied to. |


### Beta

Attributes for elastic agents:

* `node['gocd']['agent']['elastic']['plugin_id']` - The elastic agent plugin id. This is used to set the autoregister property `agent.auto.register.elasticAgent.pluginId`
* `node['gocd']['agent']['elastic']['agent_id']`  - The elastic agent id used to set the autoregister property `agent.auto.register.elasticAgent.agentId`.

#### Golang agent support

By default `node['gocd']['agent']['type']` is set to `java`. Set it to `golang`
to install [GoCD agent written in Go](https://github.com/gocd-contrib/gocd-golang-agent).
Note that this agent has quite a few limitations.

### Deprecated

Please use `node['gocd']['agent']['go_server_url']` instead of the following deprecated attributes:

* `node['gocd']['agent']['go_server_host']` - The hostname of the go server (if left alone, will be auto-detected). Defaults to `nil`.
* `node['gocd']['agent']['go_server_port']` - The port of the go server. Defaults to `8153`.

# GoCD Agent LWRP (currently only works on linux)

If the agent recipe + attributes is not flexible enough or if you prefer chef resources
then you can add go-agent services with the `gocd_agent` LWRP.

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
  autoregister_environments 'production'
  autoregister_resources     ['java-8','ruby-2.2']
  workspace     '/mnt/big_drive'
end
```

# GoCD autoregister file resource

If you want to set up agents *your-way* then this resource is helpful to **only**
generate a valid `autoregister.properties` file:

Example use:
```ruby
gocd_agent_autoregister_file '/var/mygo/autoregister.properties' do
  autoregister_key 'bla-key'
  autoregister_hostname 'mygo-agent'
  autoregister_environments 'stage'
  autoregister_resources     ['java-8','ruby']
end
```

Can be used to prepare elastic agents too:
```ruby
gocd_agent_autoregister_file '/var/elastic/autoregister.properties' do
  autoregister_key 'some-key'
  autoregister_hostname 'elastic-agent'
  autoregister_environments 'testing'
  autoregister_resources     ['java-8']
  elastic_agent_id 'agent-id'
  elastic_agent_plugin_id 'elastic-agent-plugin-id'
end
```

# GoCD plugin LWRP

You can install Go server plugins with the `gocd_plugin` LWRP like this

```ruby
include_recipe 'gocd::server'

gocd_plugin 'github-pr-status' do
  plugin_uri 'https://github.com/gocd-contrib/gocd-build-status-notifier/releases/download/1.1/github-pr-status-1.1.jar'
end
```

# Server Specification

When using the cookbook please refer to the [server specification section](https://docs.gocd.org/current/installation/system_requirements.html) of the GoCD documentation.

# License

Apache License, Version 2.0
