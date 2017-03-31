name             'gocd'
description      'Installs/Configures Go servers and agents'
maintainer       'GoCD Contributors'
maintainer_email 'go-cd@googlegroups.com'
version          '1.3.2'
source_url       'https://github.com/gocd-contrib/go-cookbook' if respond_to?(:source_url)
issues_url       'https://github.com/gocd-contrib/go-cookbook/issues' if respond_to?(:issues_url)
chef_version     '~> 12'
license          'Apache v2.0'

supports 'ubuntu'
supports 'centos'
supports 'redhat'
supports 'windows'

recipe 'gocd::server', 'Installs and configures a Go server'
recipe 'gocd::agent', 'Installs and configures a Go agent'
recipe 'gocd::repository', 'Installs the go yum/apt repository'
recipe 'gocd::agent_windows', 'Installs and configures Windows Go agent'
recipe 'gocd::server_windows', 'Installs and configures Windows Go server'
recipe 'gocd::agent_linux', 'Install and configures Linux Go agent'
recipe 'gocd::server_linux', 'Install and configures Linux Go server'

depends 'apt', '>= 3.0.0'
depends 'java'
depends 'yum'
depends 'windows'
