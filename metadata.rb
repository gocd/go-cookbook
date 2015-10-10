name             "gocd"
description      "Installs/Configures Go servers and agents"
version          "1.0.0"

supports "ubuntu"
supports "centos"
supports "redhat"
supports "windows"

recipe "gocd::server", "Installs and configures a Go server"
recipe "gocd::agent", "Installs and configures a Go agent"
recipe "gocd::repository", "Installs the go yum/apt repository"
recipe "gocd::agent_windows", "Installs and configures Windows Go agent"
recipe "gocd::agent_linux", "Install and configures Linux Go agent"

depends "apt"
depends "java"
depends "yum"
depends "windows"
