# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # Store directory name as reference to sitename
  vagrant_sitename = File.basename(Dir.pwd); #taken from VVV
  vagrant_domain = "#{vagrant_sitename}.dev"
  vagrant_ip = "192.168.32." + rand(256).to_s

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/xenial64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "#{vagrant_ip}"
  config.vm.hostname = "#{vagrant_domain}"
  config.hostsupdater.aliases = ["mail.#{vagrant_domain}"]

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "www/", "/srv/www/", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]
  config.vm.synced_folder "logs/", "/srv/logs", :owner => "www-data"
  config.vm.synced_folder "config/", "/srv/config"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  config.vm.provider "virtualbox" do |vb|
    vb.gui  = false
    vb.name = vagrant_sitename
    vb.customize ["modifyvm", :id, "--memory", 512]
    vb.customize ["modifyvm", :id, "--cpus", 1]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a default Vagrant Push strategy for pushing to Atlas. See the
  # documentation at https://docs.vagrantup.com/v2/push/atlas.html
  # for more information.
  # config.push.define "ftp" do |push|
  #   push.host = "ftp.example.com"
  #   push.username = "username"
  #   push.password = "password"
  #   push.secure = true
  #   push.destination = "/public_html"
  #   push.dir = "www"
  # end

  # Fix no-tty issue
  # See: https://github.com/mitchellh/vagrant/issues/1673
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", path: "provision.sh", args: "#{vagrant_domain}"
end
