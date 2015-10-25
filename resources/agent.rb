#Base Resource
actions :create, :delete

default_action :create if defined?(default_action)

attribute :service_action, :kind_of => [ Symbol, Array ], :required => false, :default => [:enable,:start]

attribute :agent_name, :name_attribute => true, :kind_of => String, :required => false, :default => 'go-agent'

attribute :user, :kind_of => String, :required => false, :default => 'go'
attribute :group, :kind_of => String, :required => false, :default => 'go'
attribute :go_server_host, :kind_of => String, :required => false, :default => nil
attribute :go_server_port, :kind_of => Integer, :required => false, :default => node['gocd']['agent']['go_server_port']
attribute :daemon, :kind_of => [ TrueClass, FalseClass ], :required => false, :default => node['gocd']['agent']['daemon']
attribute :vnc, :kind_of => [ TrueClass, FalseClass ], :required => false, :default => node['gocd']['agent']['vnc']['enabled']
attribute :autoregister_key, :kind_of => String, :required => false, :default => nil
attribute :autoregister_hostname, :kind_of => String, :required => false, :default => nil
attribute :environments, :kind_of => [ String, Array ], :required => false, :default => nil
attribute :resources, :kind_of => [ String, Array ], :required => false, :default => nil
attribute :workspace, :kind_of => String, :required => false, :default => nil
