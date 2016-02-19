default['gocd']['install_method'] = 'repository'
default['gocd']['download']['baseurl'] = 'https://download.go.cd'

default['gocd']['repository']['apt']['uri'] = node['gocd']['download']['baseurl']
default['gocd']['repository']['apt']['components'] = [ '/' ]
default['gocd']['repository']['apt']['distribution'] = ''
default['gocd']['repository']['apt']['package_options'] = ''
default['gocd']['repository']['apt']['keyserver'] = 'pgp.mit.edu'
default['gocd']['repository']['apt']['key'] = '0xd8843f288816c449'

default['gocd']['repository']['yum']['baseurl'] = node['gocd']['download']['baseurl']
default['gocd']['repository']['yum']['gpgcheck'] = true
default['gocd']['repository']['yum']['gpgkey'] = 'https://download.go.cd/GOCD-GPG-KEY.asc'

case node['gocd']['install_method']
when 'repository'
# version = nil so just pick latest available
else
  default['gocd']['version'] = '16.2.1-3027'
end

version = node['gocd']['version']
os_dir = nil

case node['platform_family']
when 'debian'
  default['gocd']['server']['package_file']['filename'] = "go-server-#{version}.deb"
  default['gocd']['agent']['package_file']['filename'] = "go-agent-#{version}.deb"
  default['gocd']['package_file']['baseurl'] = node['gocd']['download']['baseurl']
  os_dir = 'deb'
when 'rhel', 'fedora'
  default['gocd']['server']['package_file']['filename'] = "go-server-#{version}.noarch.rpm"
  default['gocd']['agent']['package_file']['filename'] = "go-agent-#{version}.noarch.rpm"
  default['gocd']['package_file']['baseurl'] = node['gocd']['download']['baseurl']
  os_dir = 'rpm'
when 'windows'
  default['gocd']['server']['package_file']['filename'] = "go-server-#{version}-setup.exe"
  default['gocd']['agent']['package_file']['filename'] = "go-agent-#{version}-setup.exe"
  default['gocd']['package_file']['baseurl'] = node['gocd']['download']['baseurl']
  os_dir = 'win'
end

default['gocd']['server']['package_file']['path'] =
  File.join(Chef::Config[:file_cache_path], node['gocd']['server']['package_file']['filename'])
default['gocd']['server']['package_file']['url'] =
  "#{node['gocd']['package_file']['baseurl']}/binaries/#{version}/#{os_dir}/#{node['gocd']['server']['package_file']['filename']}"
default['gocd']['agent']['package_file']['path'] =
  File.join(Chef::Config[:file_cache_path], node['gocd']['agent']['package_file']['filename'])
default['gocd']['agent']['package_file']['url'] =
  "#{node['gocd']['package_file']['baseurl']}/binaries/#{version}/#{os_dir}/#{node['gocd']['agent']['package_file']['filename']}"
