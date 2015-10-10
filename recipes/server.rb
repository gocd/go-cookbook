case node['platform']
when 'windows'
  include_recipe 'gocd::server_windows'
else
  include_recipe 'gocd::server_linux'
end
