include_recipe 'gocd::server'

gocd_plugin 'github-pr-status' do
  plugin_uri 'https://github.com/gocd-contrib/gocd-build-status-notifier/releases/download/1.1/github-pr-status-1.1.jar'
end
