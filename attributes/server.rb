default['gocd']['server']['http_port']    = 8153
default['gocd']['server']['https_port']   = 8154
default['gocd']['server']['max_mem']      = "2048m"
default['gocd']['server']['min_mem']      = "1024m"
default['gocd']['server']['max_perm_gen'] = "400m"
default['gocd']['server']['work_dir']     = "/var/lib/go-server"

if platform?('windows')
	default['gocd']['server']['work_dir']     = 'C:\GoServer'
end

default['gocd']['server']['wait_up']['retry_delay'] = 10
default['gocd']['server']['wait_up']['retries']     = 10
default['gocd']['server']['default_extras']         = {}