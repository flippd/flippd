#!/bin/bash

cd /vagrant

echo "Install project-specific dependencies"
bundle install > /dev/null

echo "Use foreman to export upstart configuration"
# Fix the PATH and GEM_PATH for the web server
# (can't see how to configure foreman to access chruby from upstart)
# https://github.com/ddollar/foreman/wiki/Exporting-for-production
echo "PATH=$PATH" > /tmp/foreman.env
echo "GEM_PATH=$GEM_PATH" >> /tmp/foreman.env
bundle exec foreman export upstart --env=/tmp/foreman.env --app=hello --user=vagrant /tmp

echo "Use upstart to ensure web server restarts on boot"
sudo mv /tmp/hello*.conf /etc/init

sudo start hello
