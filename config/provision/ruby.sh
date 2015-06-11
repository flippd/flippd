#!/bin/bash

echo "Installing ruby-install"
cd /tmp
wget -q -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz
tar -xzvf ruby-install-0.5.0.tar.gz > /dev/null
cd ruby-install-0.5.0/
sudo make -s install

echo "Installing chruby"
cd /tmp
wget -q -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz > /dev/null
cd chruby-0.3.9/
sudo scripts/setup.sh > /dev/null

echo "Installing Ruby"
ruby-install ruby 2.2.1 &> /dev/null

echo "Switching to Ruby 2.2.1"
source /etc/profile.d/chruby.sh
cd /vagrant

echo "Installing bundler"
gem install bundler > /dev/null
