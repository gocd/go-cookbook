# 3.0.1

* [8f34eb6](https://github.com/gocd/go-cookbook/commit/8f34eb6) - Set correct package name for Windows based on arch
* [ea191db](https://github.com/gocd/go-cookbook/commit/ea191db) - Update foodcritic version to 12.2.1

# 3.0.0

* Supports Chef 13

## Breaking Changes

* [4f82f84](https://github.com/gocd/go-cookbook/commit/4f82f84) - The `resources` and `environments` properties in our custom resources `gocd_agent` and `gocd_agent_autoregister_file` are removed in favour of `autoregister_resources` and `autoregister_environments`.

## Fixes

* [607f3e8](https://github.com/gocd/go-cookbook/commit/607f3e8) - Change all URLs from gocd.io to gocd.org
* [5fd066f](https://github.com/gocd/go-cookbook/commit/5fd066f) - Update foodcritic version to use the one used on supermarket.
* [5fd066f](https://github.com/gocd/go-cookbook/commit/5fd066f) - Update foodcritic licensing format.

# 2.0.0

## Breaking changes

* The attributes `go_server_host` and `go_server_port` are removed in favour of `go_server_url`

## Deprecations

* The `resources` and `environments` properties in our custom resources `gocd_agent` and `gocd_agent_autoregister_file` are deprecated in favour of `autoregister_resources` and `autoregister_environments`.
They will be removed in one of the upcoming releases. Please use `autoregister_resources` and `autoregister_environments` henceforth. 

## Bug Fixes

* [236f6cd](https://github.com/gocd/go-cookbook/commit/236f6cd) - Explicitly specify provider to be systemd for ubuntu 16.04.
* [d637543](https://github.com/gocd/go-cookbook/commit/d637543) - Change package name for debian to include substring '_all'.


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
