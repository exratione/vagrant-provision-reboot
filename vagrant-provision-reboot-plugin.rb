# A quick hack to allow rebooting of a Vagrant VM during provisioning.
#
# Adapted from: https://gist.github.com/ukabu/6780121
#
# This file should be placed into the same folder as your Vagrantfile. Then in
# your Vagrantfile, you'll want to do something like the following:
#
# ----------------------------------------------------------------------------
#
# require './vagrant-provision-reboot-plugin'
#
# Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
#
#   # Run your pre-reboot provisioning block.
#   #config.vm.provision :chef_solo do |chef|
#   #  ...
#   #end
#
#   # Run a reboot of a *NIX guest.
#   config.vm.provision :unix_reboot
#   # Run a reboot of a Windows guest, assuming that you are set up with the
#   # relevant plugins and configurations to manage a Windows guest in Vagrant.
#   #config.vm.provision :windows_reboot
#
#   # Run your post-reboot provisioning block.
#   #config.vm.provision :chef_solo do |chef|
#   #  ...
#   #end
#
# ----------------------------------------------------------------------------
#
# The provisioner takes care of remounting the shared folders.
#
# This will work for the VirtualBox provider, for other providers, a
# 'remap_shared_folders' action must be added to the provider implementation.

require 'vagrant'

# Monkey-patch VirtualBox provider to be able to remap shared folders after
# reboot.
module VagrantPlugins
  module ProviderVirtualBox
    module Action

      class MountSharedFolders < ShareFolders
        def initialize(app,env)
          super(app, env)
        end

        def call(env)
          @env = env
          @app.call(env)
          mount_shared_folders
        end
      end

      def self.action_remap_shared_folders
        Vagrant::Action::Builder.new.tap do |b|
          b.use MountSharedFolders
        end
      end

    end
  end
end

# Define the plugin.
class RebootPlugin < Vagrant.plugin('2')
  name 'Reboot Plugin'

  # This plugin provides a provisioner called unix_reboot.
  provisioner 'unix_reboot' do

    # Create a provisioner.
    class RebootProvisioner < Vagrant.plugin('2', :provisioner)
      # Initialization, define internal state. Nothing needed.
      def initialize(machine, config)
        super(machine, config)
      end

      # Configuration changes to be done. Nothing needed here either.
      def configure(root_config)
        super(root_config)
      end

      # Run the provisioning.
      def provision
        command = 'shutdown -r now'
        @machine.ui.info("Issuing command: #{command}")
        @machine.communicate.sudo(command) do |type, data|
          if type == :stderr
            @machine.ui.error(data);
          end
        end

        begin
          sleep 5
        end until @machine.communicate.ready?

        # Now the machine is up again, perform the necessary tasks.
        @machine.action('remap_shared_folders')
      end

      # Nothing needs to be done on cleanup.
      def cleanup
        super
      end
    end
    RebootProvisioner

  end

  # This plugin provides a provisioner called windows_reboot.
  provisioner 'windows_reboot' do

    # Create a provisioner.
    class RebootProvisioner < Vagrant.plugin('2', :provisioner)
      # Initialization, define internal state. Nothing needed.
      def initialize(machine, config)
        super(machine, config)
      end

      # Configuration changes to be done. Nothing needed here either.
      def configure(root_config)
        super(root_config)
      end

      # Run the provisioning.
      def provision
        command = 'shutdown -t 0 -r -f'
        @machine.ui.info("Issuing command: #{command}")
        @machine.communicate.execute(command) do
          if type == :stderr
            @machine.ui.error(data);
          end
        end

        begin
          sleep 5
        end until @machine.communicate.ready?

        # Now the machine is up again, perform the necessary tasks.
        @machine.action('remap_shared_folders')
      end

      # Nothing needs to be done on cleanup.
      def cleanup
        super
      end
    end
    RebootProvisioner

  end
end
