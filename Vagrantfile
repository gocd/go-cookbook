require 'berkshelf/vagrant'

Vagrant::Config.run do |config|
  config.vm.host_name = "go-server-berkshelf"

  config.vm.box = "opscode_ubuntu-12.04_chef-11.2.0"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_chef-11.2.0.box"

  config.vm.network :hostonly, "33.33.33.10"
  config.ssh.max_tries = 40
  config.ssh.timeout   = 120

  # config.vm.share_folder "keypath", "/tmp/host-chef-secrets", "../../.chef/encrypted_data_bag_secret"
  
  config.vm.provision :chef_solo do |chef|
    # chef.log_level = "debug"
    # chef.encrypted_data_bag_secret = "/tmp/host-chef-secrets/key"

    # chef.roles_path = "../../roles/"
    # chef.data_bags_path = "../../data_bags/"
    chef.json = {
      # "chef_environment" => "pipeline_dev"
      "go" => {
        "server" => "127.0.0.1",
        "auto_register_agents" => true,
        "auto_register_agents_key" => "batshit"
      }
    }

    chef.run_list = [
      "recipe[go::server]","recipe[go::agent]"
    ]
  end
end
