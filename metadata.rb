name             "go"
description      "Installs/Configures Go servers and agents"
version          "0.0.11"

supports "ubuntu", ">= 12.04"
supports "centos"
supports "windows"

recipe "go::server", "Installs and configures a Go server"
recipe "go::agent", "Installs and configures a Go agent"
recipe "go::default", "Installs and configures a Go server and agent on the same node, for windows just agent"
recipe "go::agent_windows", "Installs and configures Windows Go agent"

depends "apt", ">= 1.9.2"
depends "java", ">= 1.10.0"
depends "yum", ">= 3.0.0"
depends "windows", ">= 1.2.6"