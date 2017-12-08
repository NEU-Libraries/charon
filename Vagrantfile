# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = "charon"

  config.vm.box = "bento/centos-7.3"

  config.vm.network :forwarded_port, guest: 3000, host: 3000 # Rails
  config.vm.network :forwarded_port, guest: 8983, host: 8983 # Solr
  config.vm.network :forwarded_port, guest: 8984, host: 8984 # Fedora

  config.vm.provider "virtualbox" do |v|
    v.memory = 3072
  end

  config.vm.synced_folder "." , "/home/vagrant/charon", nfs: true
  config.vm.network "private_network", ip: "192.168.50.4"

  config.vm.provision "shell", path: "script/vagrant_provisioning.sh", privileged: false
end
