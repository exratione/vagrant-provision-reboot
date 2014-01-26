Vagrant Provision Reboot Plugin
===============================

Provisioning a Vagrant box with software or configuration changes that require a
reboot can be a challenge.

This repository demonstrates a Vagrant plugin that allows a provisioning block
in the Vagrantfile to reboot the VM, followed by remapping shared folders once
the VM is running again.

This was tested in Vagrant 1.4.3, but since it involves tinkering with
non-public APIs you shouldn't expect it to be terribly stable over time. It
certainly won't work in earlier 1.3.* versions of Vagrant, for example.

Usage
-----

Since provisioning blocks run in order, you can perform provisioning actions
both before and after reboot:

```
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

Try the Example Vagrantfile
---------------------------

Clone this repository and then launch one of the configured VMs:

    vagrant up centos-6.4-x86_64
    vagrant up ubuntu-precise-x86_64

The CentOS box runs with a GUI and is generally cranky. It fails 10-20% of the
time on mapping shared folders and has timing issues when establishing a
communication channel between host and guest. This is among the perils of trying
to work with the GUI enabled in Vagrant and happens whether or not you are
using the reboot plugin.

The Ubuntu option is a headless VM that runs and reboots with no issues.

If you want to experiment with Windows VMs, then you are on your own. It may
work, indeed it should work - but it hasn't been tested. You will certainly
need to install the additions to core Vagrant for working with Windows guest
VMs.
