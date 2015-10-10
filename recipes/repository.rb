case node['platform_family']
when 'debian'
  include_recipe 'apt'

  apt_repository 'gocd' do
    uri 'http://dl.bintray.com/gocd/gocd-deb/'
    keyserver "pgp.mit.edu"
    key "0x9149B0A6173454C7"
    components ['/']
  end

when 'rhel', 'fedora'
  include_recipe 'yum'

  yum_repository 'gocd' do
    baseurl 'http://dl.bintray.com/gocd/gocd-rpm/'
    gpgcheck false
  end
end
