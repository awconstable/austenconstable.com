# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/bionic64"

  config.vm.provider "virtualbox" do |vb|
     vb.gui = true
  
     vb.memory = "4096"
  end
  
  config.vm.provision "shell", inline: <<-SHELL

    sudo apt-get install language-pack-en
    sudo locale-gen en_GB.UTF-8

    sudo apt-get update
    sudo apt-get -y upgrade

    sudo apt-get install -y git

    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    sudo apt-get install -y nodejs

    sudo apt-get -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

    sudo apt-get update

    sudo apt-get -y install docker-ce docker-compose ruby ruby-dev build-essential patch zlib1g-dev liblzma-dev

    sudo usermod -aG docker vagrant

    sudo apt-get -y autoremove

    echo "cd /vagrant" >> /home/vagrant/.bashrc
  SHELL

  config.vm.provision "Copy user's git config", type:'file', source: '~/.gitconfig', destination: '.gitconfig'

end
