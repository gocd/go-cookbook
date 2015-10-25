# must be early so that java home attrbute gets assigned soon enough
node.force_default['java']['jdk_version'] = '7'
include_recipe 'java'
