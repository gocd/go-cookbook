# GoCD Cookbook

This cookbook is here to help you setup Go servers and agents in an automated way.

## Supported Platforms

This cookbook has been tested on the following platforms:

* Ubuntu >= 12.04
* Debian
* CentOS >= 6
* RedHat >= 6
* Windows - primitive support, but enhancements welcome :)

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

# License

Apache License, Version 2.0
