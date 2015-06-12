#!/bin/bash

echo "Updating apt-get cache"
sudo apt-get update --yes > /dev/null

echo "Adding extra apt repositories for Ruby binaries"
sudo apt-get install --yes software-properties-common > /dev/null
sudo apt-add-repository --yes ppa:brightbox/ruby-ng &> /dev/null
sudo apt-get update --yes > /dev/null

echo "Installing Ruby 2.2"
sudo apt-get install --yes ruby2.2 &> /dev/null

echo "Installing ruby-switch"
sudo apt-get install --yes ruby-switch &> /dev/null

echo "Make Ruby 2.2 the default"
sudo ruby-switch --set ruby2.2 > /dev/null

echo "Installing bundler"
sudo gem install bundler > /dev/null
