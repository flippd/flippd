#!/bin/bash

HOSTNAME=flippd-web-1

echo "Setting hostname"
echo $HOSTNAME | sudo tee /etc/hostname > /dev/null
sudo hostname -F /etc/hostname

echo "Setting timezone"
sudo timedatectl set-timezone Europe/London
echo " - Time is now `date`"

echo "Installing software updates"
sudo apt-get update --yes &> /dev/null
sudo apt-get upgrade --yes --show-upgraded &> /dev/null
