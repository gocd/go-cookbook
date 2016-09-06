actions :create, :delete

default_action :create if defined?(default_action)

property :plugin_name, :name_attribute => true, :kind_of => String, :required => true
property :plugin_uri, :kind_of => String, :required => true
property :server_work_dir, :kind_of => String, :required => false, :default => node['gocd']['server']['work_dir']

action :create do
  include_recipe 'gocd::server_linux_install'

  plugin_name = new_resource.plugin_name
  server_work_dir = new_resource.server_work_dir
  plugin_uri = new_resource.plugin_uri
  remote_file "#{server_work_dir}/plugins/external/#{plugin_name}.jar" do
    source plugin_uri
    owner 'go'
    group 'go'
    mode 0770
    retries 5
  end
end
