# must be early so that java home attrbute gets assigned soon enough
node.default!['java']['jdk_version'] = '8'
include_recipe 'java'
