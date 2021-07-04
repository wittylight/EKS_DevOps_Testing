#!/bin/bash

# Wait for cloud-init to do its thing
timeout 600 /bin/bash -c \
  "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"

# Literally throw away everything cloud-init has done
echo "Cleaning apt-cache..."
sudo rm -rf /var/lib/apt/lists/* &>/dev/null
sudo apt-get -y clean &>/dev/null

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo "Updating apt-cache..."
yes | sudo aptdcon --hide-terminal --refresh
yes | sudo aptdcon --hide-terminal --safe-upgrade

echo "Installing Docker..."
yes | sudo aptdcon --hide-terminal --install "docker-ce golang-go"
sudo usermod -aG docker ubuntu
sudo curl -L https://github.com/docker/compose/releases/download/1.28.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#sudo curl -O https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz
#sudo tar -xvf go1.9.1.linux-amd64.tar.gz
#sudo mv go /usr/local
#sudo echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bash_profile

sudo mkdir /src
cd /src
sudo git clone https://github.com/algolia/sup3rS3cretMes5age.git
