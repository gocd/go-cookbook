include_recipe "gocd::agent_windows_install"

service "Go Agent" do
  supports :status => true, :restart => true, :start => true, :stop => true
  action [:enable, :start]
end
