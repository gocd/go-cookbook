box_name = "opscode_ubuntu-12.04_chef-11.2.0"
box_url  = "https://opscode-vm.s3.amazonaws.com/vagrant/#{box_name}.box"
api_version = "2"

Vagrant::configure(api_version) do |config|
  config.berkshelf.enabled    = true
  config.vm.box               = box_name
  config.vm.box_url           = box_url

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.network :private_network, ip: "192.168.192.2"

  config.vm.provision :chef_solo do |chef|
    chef.log_level = "info"
    chef.json = {
      "go" => {
        "server" => "127.0.0.1",
        "agent" => {
          "auto_register" => true,
          "instance_count" => 3
        }
      }
    }

    chef.run_list = [
      "recipe[go]"
    ]
  end
end

