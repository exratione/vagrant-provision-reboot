Vagrant Provision Reboot Plugin
===============================

Provisioning a Vagrant box with software or configuration changes that require a
reboot can be a challenge. Admittedly it isn't a common requirement in the Linux
world, but it does show up from time to time, and can be very inconvenient when
it does.

This repository demonstrates a Vagrant plugin that allows a provisioning block
in the Vagrantfile to reboot the VM, followed by remapping shared folders once
the VM is running again.

Vagrant Version Support
-----------------------

This has been tested in Vagrant 1.4.3 and 1.6.1. It is a fair assumption that it
will work in intervening versions as well.

Since this involves tinkering with non-public APIs you should not expect it to
be terribly stable over time, however. It certainly doesn't work in Vagrant
1.3.* or earlier versions for example.

A More Robust Alternative
-------------------------

You should find that the [vagrant-reload plugin][1] is a more robust alternative
to this approach. It makes use of the defined reload behavior, which should be
much more resilient to future changes.

Usage
-----

To use the provision reboot plugin, add vagrant-provision-reboot-plugin.rb into
your project folder and include it in your Vagrantfile as shown below.

Since provisioning blocks run in order, and rebooting is just another provision
block so far as Vagrant is concerned, you can perform other provisioning actions
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

Try the Example Vagrantfile
---------------------------

Clone this repository and then launch one of the configured VMs:

    vagrant up centos-6.4-x86_64
    vagrant up ubuntu-precise-x86_64

The CentOS box runs with a GUI and is generally cranky. It fails 10-20% of the
time on mapping shared folders and has timing issues when establishing a
communication channel between host and guest. These are among the perils of
trying to work with the GUI enabled in Vagrant and happens whether or not you
are using the reboot plugin.

The Ubuntu option is a headless VM that runs and reboots with no issues.

If you want to experiment with Windows VMs, then you are on your own. It may
work, indeed it should work - but it hasn't been tested. Regardless, you will
certainly need to install the additions to core Vagrant required to work with
Windows guest VMs.

[1]: https://github.com/aidanns/vagrant-reload
