# Go Cookbook

Hello friend! This cookbook is here to help you setup Go servers and agents
in an automated way. Currently, this repo is blank, but every project starts
from a humble beginning, does it not?

## Ideas

- How generic should we make this? All platforms or a handful?
- Test it with [test-kitchen](https://github.com/opscode/test-kitchen)?
- Can we enable pipeline configuration via chef?

# Go Server

go::server will install and start an empty Go server.

# Go Agent

Linux

vagrant up command now requires ubuntu box name for older versions of vagrant (vagrant up ubuntu)
ubuntu is the default for newer versions

go::agent will install and configure a Go agent, and associate it with an existing Go server.  By default it will install one agent per CPU.  You can override this via node[:go][:agent][:instance_count].

# Single Node
go::default will install both on the same node for Linux OS.

Windows

You can use Vagrant and your own chef bootstrapped virtual box base image and vagrant up windows

go recipe will install and configure a Windows Go agent on a Windows os, and associate it with an existing Go server.  Does not automatically register agent.

Overrides available for go::agent_windows
[:go][:agent][:server_host] - hostname or ip of Go server
[:go][:agent][:install_path] - installation path for Go agent
[:go][:agent][:java_home] - java home path if using existing java installation
[:go][:agent][:download_url] - msi for agent install, if left empty will build download url using [:go][:version]

# Authors
Author:: Chris Kozak (<ckozak@gmail.com>)
Author:: Tim Brown (<tpbrown@gmail.com>)