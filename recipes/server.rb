# Cookbook Name:: go
# Recipe:: server

case node['platform']
when 'windows'
  include_recipe 'go::server_windows'
else
  include_recipe 'go::server_linux'
end
