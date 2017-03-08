# Upcoming Release

## Breaking changes

* The attributes `go_server_host` and `go_server_port` are removed in favour of `go_server_url`

# 1.3.2

* Changes all URLs from go.cd to gocd.io.

# 1.3.1

 * #93 Fix GO_SERVER_URL not being set correctly on windows
 * #92 fix several issues with installing server on windows
 * replaced obsolete gpg key
 * install golang agent as a binary from bintray

# 1.3.0

 * rewritten chef resources to use new custom resource syntax
 * updated agent startup config files to use `GO_SERVER_URL` instead of host and port
 * by default install java 8
 * isolated gocd_agent_autoregister_file resource
 * added golang agent support
 * use apt cookbook >= 3.0

# 1.2.0

 * Improved version handling and installing on windows #63 #67
 * fixed autoregister value - `daemon` #88
 * added maintainer and maintainer_email to metadata, #84

# 1.1.1

* Default to using latest version, when using a platform that supports it

# 1.1.0

* Improve support for installing GoCD on windows
* Use https://download.go.cd for all repositories

# 1.0.0

Rewrite from scratch.

* GH-26 now cookbook defaults to installing latest stable
* GH-48 changed root of attributes to `gocd`
* GH-50 - installing from non-official sources - custom package file or custom apt repository.
* GH-56 - now agents can be provisioned with `gocd_agent` resource
* GH-52 - added lots of tests
* GH-59 - fixed
* added small `gocd_plugin` resource which can be used to install Go server plugins.
