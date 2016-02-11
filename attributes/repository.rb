default['gocd']['install_method'] = 'repository'

default['gocd']['repository']['apt']['uri'] = 'http://dl.bintray.com/gocd/gocd-deb/'
default['gocd']['repository']['apt']['components'] = [ '/' ]
default['gocd']['repository']['apt']['distribution'] = ''
default['gocd']['repository']['apt']['package_options'] = '--force-yes'
default['gocd']['repository']['apt']['keyserver'] = 'pgp.mit.edu'
default['gocd']['repository']['apt']['key'] = '0x9149B0A6173454C7'

default['gocd']['repository']['yum']['baseurl'] = 'http://dl.bintray.com/gocd/gocd-rpm/'
default['gocd']['repository']['yum']['gpgcheck'] = false

case node['gocd']['install_method']
when 'repository'
  # version = nil so just pick latest available
else
  default['gocd']['version'] = '15.2.0-2248'
end

version = node['gocd']['version']
case node['platform_family']
when 'debian'
  default['gocd']['server']['package_file']['filename'] = "go-server-#{version}.deb"
  default['gocd']['agent']['package_file']['filename'] = "go-agent-#{version}.deb"
  default['gocd']['package_file']['baseurl'] = 'http://download.go.cd/gocd-deb'
when 'rhel','fedora'
  default['gocd']['server']['package_file']['filename'] = "go-server-#{version}.noarch.rpm"
  default['gocd']['agent']['package_file']['filename'] = "go-agent-#{version}.noarch.rpm"
  default['gocd']['package_file']['baseurl'] = 'http://download.go.cd/gocd-rpm'
end

default['gocd']['server']['package_file']['path'] =
  File.join(Chef::Config[:file_cache_path], node['gocd']['server']['package_file']['filename'])
default['gocd']['server']['package_file']['url'] =
  "#{node['gocd']['package_file']['baseurl']}/#{node['gocd']['server']['package_file']['filename']}"
default['gocd']['agent']['package_file']['path'] =
  File.join(Chef::Config[:file_cache_path], node['gocd']['agent']['package_file']['filename'])
default['gocd']['agent']['package_file']['url'] =
  "#{node['gocd']['package_file']['baseurl']}/#{node['gocd']['agent']['package_file']['filename']}"
