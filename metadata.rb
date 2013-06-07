name             "go"
description      "Installs/Configures Go servers and agents"
version          "0.0.5"

supports "ubuntu" "12.04"

recipe "go::server", "Installs and configures a Go server"
recipe "go::agent", "Installs and configures a Go agent"

depends "apt", "1.9.2"
depends "java", "1.10.0"

