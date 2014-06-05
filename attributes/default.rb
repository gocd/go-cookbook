default[:go][:backup_path] = ""
default[:go][:backup_retrieval_type] = "subversion"

default[:go][:agent][:auto_register]         = false
default[:go][:agent][:auto_register_key]     = 'default_auto_registration_key'
# Install this many agent instances on a box - default is one per CPU
default[:go][:agent][:instance_count] = node[:cpu][:total]
default[:go][:agent][:server_search_query] =
  "chef_environment:#{node.chef_environment} AND run_list:recipe\\[go\\:\\:server\\]"

default[:go][:version]                       = '13.4.1-18342'
