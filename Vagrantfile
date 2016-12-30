# -*- mode: ruby -*-
# vi: set ft=ruby :

my_name="my_name"
ip_port="ip_port"
# current_number=15

# Config Github Settings
github_username = "dodecasphere"
github_repo     = "vagrant"
github_branch   = "master"
github_url      = "https://raw.githubusercontent.com/#{github_username}/#{github_repo}/#{github_branch}"

# Hostname
hostname        = "#{my_name}.dev"

# Server Configuration
server_ip           = "192.168.22.#{ip_port}"
server_cpus         = "1"   # Cores
server_memory       = "384" # MB
server_swap         = "768" # Options: false | int (MB) - Guideline: Between one or two times the server_memory
server_timezone     = "UTC"

# Database Configuration
mysql_root_password   = "root"   # We'll assume user "root"
mysql_version         = "5.6"    # Options: 5.5 | 5.6
mysql_enable_remote   = "false"  # remote access enabled when true

database_name         = "#{my_name}"

# Languages and Packages
php_timezone          = "UTC"    # http://php.net/manual/en/timezones.php
php_version           = "7.1"    # Options: 5.5 | 5.6

# PHP Options
composer_packages     = [        # List any global Composer packages that you want to install
  #"phpunit/phpunit:4.0.*",
  #"codeception/codeception=*",
  #"phpspec/phpspec:2.0.*@dev",
  #"squizlabs/php_codesniffer:1.5.*",
]

# Node stuff
nodejs_version        = "latest"   # By default "latest" will equal the latest stable version
nodejs_packages       = [          # List any global NodeJS packages that you want to install
  #"grunt-cli",
  "gulp",
  #"bower",
  #"yo",
]

# Default web server document root
public_folder         = "/vagrant/public"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  config.vm.define "#{my_name}Box" do |vboxed|
  end

  config.vm.hostname = hostname

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 80, host: "80#{ip_port}", id: "nginx"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network :private_network, ip: server_ip

  # Enable agent forwarding over SSH connections
  config.ssh.forward_agent = true

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  # Use NFS for the shared folder
  config.vm.synced_folder ".", "/vagrant",
            id: "core",
            :nfs => true,
            :mount_options => ['nolock,vers=3,udp,noatime,actimeo=2']

 # Replicate local .gitconfig file if it exists
  if File.file?(File.expand_path("~/.gitconfig"))
    config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
  # If using VirtualBox
  config.vm.provider :virtualbox do |vb|

    vb.name = hostname

    # Set server cpus
    vb.customize ["modifyvm", :id, "--cpus", server_cpus]

    # Set server memory
    vb.customize ["modifyvm", :id, "--memory", server_memory]

    # Set the timesync threshold to 10 seconds, instead of the default 20 minutes.
    # If the clock gets more than 15 minutes out of sync (due to your laptop going
    # to sleep for instance, then some 3rd party services will reject requests.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]

    # Prevent VMs running on Ubuntu to lose internet connection
    # vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    # vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  # Provision Base Packages
  config.vm.provision "shell", path: "#{github_url}/scripts/base.sh", args: [github_url, server_swap, server_timezone]

  # optimize base box
  config.vm.provision "shell", path: "#{github_url}/scripts/base_box_optimizations.sh", privileged: true

  # Provision PHP
  config.vm.provision "shell", path: "#{github_url}/scripts/php.sh", args: [php_timezone, php_version]

  # Provision nginx Base
  config.vm.provision "shell", path: "#{github_url}/scripts/nginx.sh", args: [server_ip, public_folder, hostname]

  # Provision MySQL
  config.vm.provision "shell", path: "#{github_url}/scripts/mysql.sh", args: [mysql_root_password, mysql_version, mysql_enable_remote]

  # Install Nodejs
  config.vm.provision "shell", path: "#{github_url}/scripts/nodejs.sh", privileged: false, args: nodejs_packages.unshift(nodejs_version, github_url)

  # Provision Composer
  # You may pass a github auth token as the first argument
  config.vm.provision "shell", path: "#{github_url}/scripts/composer.sh", privileged: false, args: [composer_packages.join(" ")]

  ############################################################
  # Oh My ZSH Install section

  # Install git and zsh prerequisites
  # config.vm.provision :shell, inline: "apt-get -y install git"
  config.vm.provision :shell, inline: "apt-get -y install zsh"

  # Clone Oh My Zsh from the git repo
  config.vm.provision :shell, privileged: false,
    inline: "git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh"

  # Copy in the default .zshrc config file
  # config.vm.provision :shell, privileged: false,
  #   inline: "cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc"

  # Bring down the zshrc file
  config.vm.provision :shell, privileged: false,
    inline: "wget -O ~/.zshrc #{github_url}/shell/.zshrc"

  # Change the vagrant user's shell to use zsh
  config.vm.provision :shell, inline: "chsh -s /bin/zsh vagrant"

  # Bring down the theme file
  config.vm.provision :shell, privileged: false,
    inline: "wget -O ~/.oh-my-zsh/themes/mycloud.zsh-theme #{github_url}/shell/mycloud.zsh-theme"

  ############################################################

  # Setup Database
  config.vm.provision "shell", path: "#{github_url}/scripts/database.sh", args: [database_name]

end
