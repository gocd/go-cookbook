actions :create, :delete

default_action :create if defined?(default_action)

attribute :plugin_name, :name_attribute => true, :kind_of => String, :required => true
attribute :plugin_uri, :kind_of => String, :required => true
attribute :server_work_dir, :kind_of => String, :required => false, :default => node['gocd']['server']['work_dir']
