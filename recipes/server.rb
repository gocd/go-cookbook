include_recipe 'apt'
include_recipe 'java'

package 'unzip'

apt_repository "thoughtworks" do
  uri "http://download01.thoughtworks.com/go/debian"
  components ["contrib/"]
end

package "go-server" do
  version node[:go][:version]
  options "--force-yes"
  notifies :start, 'service[go-server]', :immediately
end

# If we're upgrading an existing Go Server then leave the configuration and such intact. 
# If it's a new node, and a SVN backup URL is specified then restore/overwrite any existing configuration.

# Detection isn't based on the <license> element as Go-Community edition has no license. 
# We look for at least one <pipelines> element, with the assumption that if you have a backup you have at least one pipeline.

if (::File.exists?('/etc/go/cruise-config.xml') and ::File.readlines('/etc/go/cruise-config.xml').grep(/<pipelines/).length > 0) 
  skip_backup = true
  Chef::Log.warn("Existing configuration detected. Restore skipped.")
else
  Chef::Log.warn("New install detected.")
  skip_backup = false
  restore_go_config = false
  if (node[:go][:backup_path] && !node[:go][:backup_path].strip.empty?) 
    Chef::Log.warn("Backup URL specified. Configuration will be restored.")
    restore_go_config = true
  end
end

# Grab the backup out of Subversion
subversion "restore-go-config" do
  Chef::Log.info("Restoring configuration from #{node[:go][:backup_path]}")
  repository node[:go][:backup_path]
  destination "#{Chef::Config[:file_cache_path]}/go-config-restore"
  action :force_export
  notifies :stop, 'service[go-server-control]', :immediately
  not_if {skip_backup}
  only_if {restore_go_config}
end

# Trash and restore the H2 Database
file "/var/lib/go-server/db/h2db/cruise.h2.db" do
  action :delete
  not_if {skip_backup}
  only_if {restore_go_config}
end

execute "restore_db" do
  Chef::Log.info("Restoring h2db")
  command "unzip -q -u -o #{Chef::Config[:file_cache_path]}/go-config-restore/go-config/current/db.zip -d  /var/lib/go-server/db/h2db"
  user "go"
  group "go"
  action :run
  not_if {skip_backup}
  only_if {restore_go_config}
end

# Trash and restore the /etc/go configuration.  Noted side-effect of this approach is that /etc/go is owned by Go, not root.
directory "/etc/go" do
  action :delete
  recursive true
  not_if {skip_backup}
  only_if {restore_go_config}
end
directory "/etc/go" do
  action :create
  user "go"
  group "go"
  not_if {skip_backup}
  only_if {restore_go_config}
end
execute "restore_config" do
  command "unzip -q -u -o #{Chef::Config[:file_cache_path]}/go-config-restore/go-config/current/config-dir.zip -d  /etc/go"
  user "go"
  group "go"
  action :run
  not_if {skip_backup}
  only_if {restore_go_config}
end

# Trash and restore the internal Git repo that's really the source of the pipeline config.  Once this completes fire up Go.
directory "/var/lib/go-server/db/config.git" do
  action :delete
  recursive true
  not_if {skip_backup}
  only_if {restore_go_config}
end
directory "/var/lib/go-server/db/config.git" do
  action :create
  user "go"
  group "go"
  not_if {skip_backup}
  only_if {restore_go_config}
end
execute "restore_config_repo" do
  command "unzip -q -u -o #{Chef::Config[:file_cache_path]}/go-config-restore/go-config/current/config-repo.zip -d  /var/lib/go-server/db/config.git"
  user "go"
  group "go"
  action :run
  not_if {skip_backup}
  only_if {restore_go_config}
  notifies :restart, 'service[go-server]', :immediately
end

# Used for stop/start in-process
service 'go-server-control' do
  service_name 'go-server'
  action :nothing
end

# Used for the lasting service config
service 'go-server' do
  supports :status => true, :restart => true, :reload => true, :start => true
  action [:enable, :nothing]
  notifies :get, 'http_request[verify_go-server_comes_up]', :immediately
end

http_request 'verify_go-server_comes_up' do
  url 'http://localhost:8153/go/home'
  retry_delay 10
  retries 10
  action :nothing
end

# Always run the publish/remove autoregister key blocks so that if the attribute gets changed dynamically we still work properly.
# If it's not run every time we could leave the autoregister key in the attributes which would be bad.  Mmm'kay?

if (Chef::Config[:solo])
  Chef::Log.warn("Automatic agent registration is not supported on chef-solo.  All attributes must be set on the agent node directly.")
end

ruby_block "publish_autoregister_key" do
  block do
    s = ::File.readlines('/etc/go/cruise-config.xml').grep(/agentAutoRegisterKey="(\S+)"/)
    if (s.length > 0)
      server_autoregister_key=s[0].to_s.match(/agentAutoRegisterKey="(\S+)"/)[1]
    else
      server_autoregister_key=""
    end

    Chef::Log.warn("Enabling automatic agent registration.  Any configured agent will be configured to build without authorization.")
    node.set[:go][:autoregister_key]=server_autoregister_key
    node.save
  end
  action :create
  only_if {node[:go][:auto_register_agents]}
  not_if {Chef::Config[:solo]}
end

ruby_block "remove_autoregister_key" do
  block do
    Chef::Log.warn("Disabling automatic agent registration.")
    node.set[:go][:autoregister_key]=""
    node.save
  end
  action :create
  not_if {node[:go][:auto_register_agents]}
  not_if {Chef::Config[:solo]}
end

