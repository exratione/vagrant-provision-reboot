# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Require the reboot plugin.
require './vagrant-provision-reboot-plugin'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Run your pre-reboot provisioning block.
  #config.vm.provision :chef_solo do |chef|
  #  ...
  #end

  # Run a reboot of a *NIX guest.
  config.vm.provision :unix_reboot
  # Run a reboot of a Windows guest, assuming that you are set up with the
  # relevant plugins and configurations to manage a Windows guest in Vagrant.
  #config.vm.provision :windows_reboot

  # Run your post-reboot provisioning block.
  #config.vm.provision :chef_solo do |chef|
  #  ...
  #end

  # With 64-bit Ubuntu 12.04 as the OS, without a GUI. This is reliable and
  # shouldn't run into any issues.
  config.vm.define "ubuntu-precise-x86_64" do |subconfig|

    subconfig.vm.box = "precise64"
    subconfig.vm.box_url = "http://files.vagrantup.com/precise64.box"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    subconfig.vm.network :private_network, ip: "192.168.34.11"

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    subconfig.vm.provider :virtualbox do |vb|
      # Don't boot with headless mode.
      #vb.gui = true

      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
  end

  # With 64-bit CentOS 6.4 as the OS, with a GUI. This is chosen because it is
  # cranky. It fails a fair amount on provisioning and mapping of shared folders
  # whatever you do, reboot or not.
  config.vm.define "centos-6.4-x86_64" do |subconfig|

    subconfig.vm.box = "centos_6.4-x86_64"
    subconfig.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    subconfig.vm.network :private_network, ip: "192.168.34.10"

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    subconfig.vm.provider :virtualbox do |vb|
      # Don't boot with headless mode.
      vb.gui = true

      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
  end

end
