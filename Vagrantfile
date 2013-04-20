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
    chef.json = {
      "go" => {
        "server" => {
        #  you can make a local cache and expose them to the vm via
        #  `python -m SimpleHTTPServer` in the location where you downloaded the packages
        #  "package_url" => "http://10.0.2.2:8000/go-server-13.1.1-16714.deb"
        },
        "agent" => {
        #  "package_url" => "http://10.0.2.2:8000/go-agent-13.1.1-16714.deb",
          "auto_register" => true
        }
      }
    }

    chef.run_list = [
      "recipe[apt]", "recipe[go::server]","recipe[go::agent]"
    ]
  end
end

