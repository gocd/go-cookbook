# Encoding: utf-8
# Cookbook Name:: go
# Recipe:: agent

case node['platform']
when 'windows'
  include_recipe 'go::agent_windows'
else
  include_recipe 'go::agent_linux'
end
