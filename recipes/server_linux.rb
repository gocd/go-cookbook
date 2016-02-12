include_recipe 'gocd::server_linux_install'

template "/etc/default/go-server" do
  source   "go-server-default.erb"
  mode     "0644"
  owner    "root"
  group    "root"
  notifies :restart, "service[go-server]", :delayed
end
