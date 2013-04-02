name             "go"
description      "Installs/Configures Go servers and agents"
version          "0.0.4"
%w{ debian ubuntu}.each do |os|
  supports os
end

recipe "go::server", "Installs and configures a Go server"
recipe "go::agent", "Installs and configures a Go agent"

depends "java", "~> 1.9.6"
