# -*- mode: ruby -*-
# vi: set ft=ruby :
def parse_config(
  config_file=File.expand_path(File.join(File.dirname(__FILE__), 'config.yml'))
)
  require 'yaml'
  config = {
    'sites' => "sites",
    'databases' => "databases",
    'memory' => '2048',
    'with_gui' => false,
    'ip' => "192.168.50.4",
    'php_version' => '5.3',
    'cpus' => '2',
    'boxname' => 'Parrot',
    'debug' => false,
  }
  if File.exists?(config_file)
    overrides = YAML.load_file(config_file)
    config.merge!(overrides)
  end
  config
end

Vagrant.configure('2') do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  custom_config = parse_config

  # Note the backticks on this next line.
  architecture = `uname -m`.strip
  if ((architecture == 'x86_64') || (architecture == 'ia64'))
    bits = 64
  else
    bits = 32
  end


  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  if (bits == 32)
    config.vm.box = "precise32"
  else
    config.vm.box = "precise64"
  end

  # Provide specific settings for VMWare Fusion
  config.vm.provider "vmware_fusion" do |box, override|
    override.vm.box = "precise64"
    override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"

    box.vmx["memsize"] = custom_config['memory']
    # Boot with a GUI so you can see the screen. (Default is headless)
    box.gui = custom_config['with_gui']
  end

  # Give the created VM 768M of RAM
  config.vm.provider :virtualbox do |box, override|
    if (bits == 32)
      override.vm.box_url = "http://files.vagrantup.com/precise32.box"
    else
      override.vm.box_url = "http://files.vagrantup.com/precise64.box"
    end

    box.customize ['modifyvm', :id, '--memory', custom_config['memory']]
    box.name = custom_config['box_name']
    # Boot with a GUI so you can see the screen. (Default is headless)
    box.gui = custom_config['with_gui']

    # Addiotional customizations can be done as noted on http://www.virtualbox.org/manual/ch08.html
    box.customize ['modifyvm', :id, '--memory', custom_config['memory']]
    box.customize ['modifyvm', :id, '--cpus', custom_config['cpus']]
    box.name = custom_config['boxname']
    # Boot with a GUI so you can see the screen. (Default is headless)
    # box.gui = true
  end

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, ip: custom_config['ip']

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.


  # Solr
  config.vm.network :forwarded_port, :guest => 8983, :host => 8983
  # MySQL
  config.vm.network :forwarded_port, :guest => 3306, :host => 3306
  # Varnish
  config.vm.network :forwarded_port, :guest => 80, :host => 8181
  # Apache
  config.vm.network :forwarded_port, :guest => 8080, :host => 8080
  # HTTPS
  config.vm.network :forwarded_port, :guest => 443, :host => 1443
  # Dovecot - IMAP
  config.vm.network :forwarded_port, :guest => 143, :host => 1143

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  config.vm.synced_folder "parrot-config", "/vagrant_parrot_config"

  config.vm.synced_folder custom_config['sites'], "/vagrant_sites", :nfs => true
  config.vm.synced_folder custom_config['databases'], "/vagrant_databases"


  # Use Vagrant Cachier
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  end

  # Enable ssh key forwarding
  config.ssh.forward_agent = true

  # A quick bootstrap to get Puppet installed.
  config.vm.provision "shell", path: "scripts/bootstrap.sh"

  # And now the meat.
  config.vm.provision :puppet do |puppet|
    if (custom_config['debug'])
      puppet.options = "--verbose --debug"
    end
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "parrot.pp"
    puppet.module_path = "modules"
    # Add a custom fact so we can reliably hit the host IP from the guest.
    puppet.facter = {
      "vagrant_guest_ip" => custom_config['ip'],
      "parrot_php_version" => custom_config['php_version']
    }
  end
  
  # A quick installation of composer and drush
  config.vm.provision "shell", path: "scripts/drush.sh"


  # Implemented based on https://www.danpurdy.co.uk/web-development/osx-yosemite-port-forwarding-for-vagrant/
  config.trigger.after [:provision, :up, :reload] do
      system('echo "
rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 80 -> 127.0.0.1 port 8080
rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 443 -> 127.0.0.1 port 1443
" | sudo pfctl -ef - > /dev/null 2>&1; echo "==> Fowarding Ports: 80 -> 8080, 443 -> 1443 & Enabling port-forwarding service (pf)"')
  end

  config.trigger.after [:halt, :destroy] do
    system("sudo pfctl -df /etc/pf.conf > /dev/null 2>&1; echo '==> Removing Port Forwarding & Disabling port-forwarding service (pf)'")
  end
end
