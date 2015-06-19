#!/bin/bash

# SSH
echo "Disabling SSH for root"
sudo sed -i "/PermitRootLogin/ s/# *PermitRootLogin/PermitRootLogin/" /etc/ssh/sshd_config
sudo sed -i "/PermitRootLogin/ s/without-password/no/" /etc/ssh/sshd_config

echo "Restarting SSH service"
sudo service ssh restart


# Firewall
echo "Installing UFW"
sudo apt-get install --yes ufw

echo "Configuring UFW"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

echo "Enabling UFW"
sudo ufw enable


# Fail2Ban
echo "Installing Fail2Ban"
sudo apt-get install --yes fail2ban

echo "Enabling Fail2Ban"
sudo service fail2ban start
