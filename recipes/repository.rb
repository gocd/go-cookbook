case node['platform_family']
when 'debian'
  include_recipe 'apt'

  apt_repository 'gocd' do
    uri apt_uri
    components node['gocd']['repository']['apt']['components']
    distribution node['gocd']['repository']['apt']['distribution']
    keyserver node['gocd']['repository']['apt']['keyserver'] unless node['gocd']['repository']['apt']['keyserver'] == false
    key node['gocd']['repository']['apt']['key'] unless node['gocd']['repository']['apt']['key'] == false
  end

when 'rhel', 'fedora'
  include_recipe 'yum'

  yum_repository 'gocd' do
    description "GoCD YUM Repository"
    baseurl yum_uri
    gpgcheck node['gocd']['repository']['yum']['gpgcheck']
    gpgkey node['gocd']['repository']['yum']['gpgkey']
  end
end
