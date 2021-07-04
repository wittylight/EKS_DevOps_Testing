#!/bin/bash

# Wait for cloud-init to do its thing
timeout 300 /bin/bash -c \
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

echo "Installing the SSM agent..."
#  Ref: https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-install-startup-linux.html
sudo snap install amazon-ssm-agent --classic

echo "Installing Docker and docker-compose..."
yes | sudo aptdcon --hide-terminal --install "docker-ce golang-go unzip"
sudo usermod -aG docker ubuntu
sudo curl -L https://github.com/docker/compose/releases/download/1.28.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Installing Ansible..."
yes | sudo aptdcon --hide-terminal --install "ansible"

echo "Installing Terraform..."
curl -sLo terraform.zip https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_linux_amd64.zip
unzip terraform.zip
sudo mv terraform /usr/local/sbin/

echo "Installing Packer..."
curl -sLo packer.zip https://releases.hashicorp.com/packer/1.6.6/packer_1.6.6_linux_amd64.zip
unzip packer.zip
sudo mv packer /usr/local/sbin/

echo "Installing Vault..."
curl -sLo vault.zip https://releases.hashicorp.com/vault/1.6.2/vault_1.6.2_linux_amd64.zip
unzip vault.zip
sudo mv vault /usr/local/sbin/

echo "Installing Consul..."
curl -sLo consul.zip https://releases.hashicorp.com/consul/1.9.3/consul_1.9.3_linux_amd64.zip
unzip consul.zip
sudo mv consul /usr/local/sbin/

echo "Install Chamber..."
curl -sLo chamber https://github.com/segmentio/chamber/releases/download/v2.9.1/chamber-v2.9.1-linux-amd64
sudo chmod +x chamber
sudo mv chamber /usr/local/sbin/chamber

echo "Install CodeDeploy agent..."
curl -sLo install https://aws-codedeploy-us-west-2.s3.us-west-2.amazonaws.com/latest/install
sudo chmod +x install
sudo ./install auto > /tmp/logfile