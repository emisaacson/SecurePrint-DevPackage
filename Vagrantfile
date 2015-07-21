# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "chef/debian-7.6"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.customize ["storageattach", :id, "--storagectl", "IDE Controller", "--port", "0", "--device", "1", "--type", "dvddrive", "--medium", "emptydrive"]
    #v.customize ["modifyvm", :id, "--accelerate3d", "on"]
    v.customize ["modifyvm", :id, "--vram", "48"]
    v.customize ["modifyvm", :id, "--usb", "on"]
    v.customize ["modifyvm", :id, "--usbehci", "on"]
  end


  config.vm.define "webapp" do |webapp|
    webapp.vm.synced_folder "salt/roots/", "/srv/salt/"
    webapp.vm.synced_folder "salt/pillar/", "/srv/pillar/"
    webapp.vm.network "forwarded_port", guest: 80, host: 8088
    webapp.vm.network "forwarded_port", guest: 22, host: 2223
    webapp.vm.network "forwarded_port", guest: 631, host: 631

    webapp.vm.provision :salt do |salt|

      salt.minion_config = "salt/minion"
      salt.run_highstate = true

    end
  end

  config.vm.define "android" do |droid|

    droid.vm.provider "virtualbox" do |v|
      v.gui = true
    end

    droid.ssh.forward_agent = true
    droid.ssh.forward_x11 = true
  
    droid.vm.provision :shell, path: "scripts/bootmeup.sh"

  end
end
