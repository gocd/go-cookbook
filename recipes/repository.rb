case node['platform_family']
when 'debian'
  include_recipe 'apt'

  apt_repository 'gocd' do
    uri node['gocd']['repository']['apt']['uri']
    keyserver node['gocd']['repository']['apt']['keyserver']
    key node['gocd']['repository']['apt']['key']
    components node['gocd']['repository']['apt']['components']
  end

when 'rhel', 'fedora'
  include_recipe 'yum'

  yum_repository 'gocd' do
    baseurl node['gocd']['repository']['yum']['baseurl']
    gpgcheck node['gocd']['repository']['yum']['gpgcheck']
  end
end
