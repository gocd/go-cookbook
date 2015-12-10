use_inline_resources

action :create do
  run_context.include_recipe 'gocd::server_linux_install'

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
