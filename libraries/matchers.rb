if defined?(ChefSpec)
  def create_gocd_agent(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gocd_agent, :create, resource_name)
  end

  def delete_gocd_agent(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gocd_agent, :delete, resource_name)
  end

  def create_gocd_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gocd_plugin, :create, resource_name)
  end

  def create_gocd_agent_autoregister_file(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gocd_agent_autoregister_file, :create, resource_name)
  end

  def delete_gocd_agent_autoregister_file(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gocd_agent_autoregister_file, :delete, resource_name)
  end
end
