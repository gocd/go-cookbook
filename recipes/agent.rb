case node['platform']
when 'windows'
  include_recipe 'gocd::agent_windows'
else
  include_recipe 'gocd::agent_linux'
end
