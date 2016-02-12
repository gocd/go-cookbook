remote_file node['gocd']['server']['package_file']['filename'] do
  path node['gocd']['server']['package_file']['path']
  source node['gocd']['server']['package_file']['url']
end

opts = []
opts << '/S'
opts << '/D=C:\GoServer'

if defined?(Chef::Provider::Package::Windows)
  package 'Go Server' do
    source node['gocd']['server']['package_file']['path']
    options opts.join(" ")
  end
else
  windows_package 'Go Server' do
    source node['gocd']['server']['package_file']['path']
    options opts.join(" ")
  end
end
