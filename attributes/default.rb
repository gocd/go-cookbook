default[:go][:release] = "13.1.1"
default[:go][:build] = "#{node[:go][:release]}-16714"
default[:go][:backup_path] = ""

default[:go][:auto_register_agents] = false

default[:go][:agent][:package_url]           = 'http://download01.thoughtworks.com/go/13.1.1/ga/go-agent-13.1.1-16714.deb'
default[:go][:agent][:package_checksum]      = '4c54e157c27087ad400341869574d0f0e3be221dcc22e864685e79032b8ace50'

default[:go][:server][:package_url]          = 'http://download01.thoughtworks.com/go/13.1.1/ga/go-server-13.1.1-16714.deb'
default[:go][:server][:package_checksum]     = '10445dc0c7b0cfe9fe32134152b0efc64592c1d50f997f43ce3f8b4576871ff7'
