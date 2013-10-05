Vagrant Reboot Provisioner
==========================

Provisioning a Vagrant box with software or configuration changes that require a
reboot can be a challenge.

This repository demonstrates a Vagrant plugin that allows a provisioning block
instruction to reboot a VM, followed by remapping shared folders once the VM is
running again.

Since provisioning blocks run in order, that means you can perform provisioning
actions both before and after reboot:

```
# Require the reboot plugin.
require './vagrant-provision-reboot-plugin'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Run your pre-reboot provisioning block.
  #config.vm.provision :chef_solo do |chef|
  #  ...
  #end

  # Run a reboot of a *NIX guest.
  config.vm.provision :unix_reboots

  # Run a reboot of a Windows guest, assuming that you are set up with the
  # relevant plugins and configurations to manage a Windows guest in
  # Vagrant.
  #config.vm.provision :windows_reboot

  # Run your post-reboot provisioning block.
  #config.vm.provision :chef_solo do |chef|
  #  ...
  #end
```

To use this just add vagrant-provision-reboot-plugin.rb into your Vagrant
project folder, and include it in your Vagrantfile as above.

Trying It Out
-------------

To try it out, clone this repository, then launch on of the configured VMs:

    vagrant up centos-6.4-x86_64
    vagrant up ubuntu-precise-x86_64

The CentOS box runs with a GUI and is generally cranky. It fails 10-20% of the
time on mapping shared folders and has timing issues when establishing a
communication channel between host and guest. This is among the perils of trying
to work with the GUI enabled in Vagrant and happens whether or not you are
using the reboot plugin.

The Ubuntu option is a headless VM that runs and reboots with no issues.
