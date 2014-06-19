default[:go][:backup_path] = ''
default[:go][:backup_retrieval_type] = 'subversion'

default[:go][:agent][:server_host]           = '127.0.0.1'
default[:go][:agent][:server_port]           = '8153'
default[:go][:agent][:auto_register]         = false
default[:go][:agent][:auto_register_key]     = 'default_auto_registration_key'

# Install this many agent instances on a box - default is one per CPU

default[:go][:agent][:instance_count] = node[:cpu][:total]

default[:go][:version]                       = '13.4.1-18342'

unless platform?('windows')
  default[:go][:agent][:java_home]             = '/usr/bin/java'
end