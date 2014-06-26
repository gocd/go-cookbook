ubuntu_box_name = 'opscode_ubuntu-12.04_chef-11.2.0'
ubuntu_box_url  = "https://opscode-vm.s3.amazonaws.com/vagrant/#{ubuntu_box_name}.box"
windows_box_name = 'vagrant-windows2008r2'
windows_box_url = "http://PUTINYOURBOXSERVERHERE/vagrant/boxes/#{windows_box_name}.box"
api_version = '2'

Vagrant::configure(api_version) do |config|
  config.berkshelf.enabled    = true

  config.vm.define 'ubuntu', primary: true do |ubuntu|
    ubuntu.vm.box               = ubuntu_box_name
    ubuntu.vm.box_url           = ubuntu_box_url

    ubuntu.vm.provider :virtualbox do |v|
      v.customize ['modifyvm', :id, '--memory', '1024']
    end

    ubuntu.vm.network :private_network, ip: '192.168.192.2'

    ubuntu.vm.provision :chef_solo do |chef|
      chef.log_level = 'info'
      chef.json = {
          'go' => {
              'server' => '127.0.0.1',
              'agent' => {
                  'auto_register' => true,
                  'instance_count' => 3
              }
          }
      }

      chef.run_list = [
          'recipe[go]'
      ]
    end
  end

  config.vm.define 'windows', autostart: false do |windows|
    windows.vm.box               = windows_box_name
    windows.vm.box_url           = windows_box_url

    windows.vm.provider :virtualbox do |v|
      v.gui = true
    end

    windows.vm.guest = :windows

    windows.vm.network :forwarded_port, guest: 5985, host: 5985, auto_correct: true

    windows.vm.network :private_network, ip: '192.168.192.3'

    windows.vm.provision :chef_solo do |chef|
      chef.log_level = 'info'
      chef.json = {
          'go' => {
              'version' => '14.1.0-18882'
          }
      }

      chef.run_list = [
          'recipe[go]'
      ]
    end
  end

end

