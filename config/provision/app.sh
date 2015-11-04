#!/bin/bash

cd /vagrant

echo "Install project-specific dependencies"
sudo apt-get --yes install libmysqlclient-dev
bundle install > /dev/null

if [ ! -f .env ]; then
    echo "Generating environment variables for use in development / test environment"
    echo "You should NOT be seeing this message if deploying to production"
    echo "COOKIE_SECRET=developer_secret" > .env
fi

echo "Use foreman to export upstart configuration"
# Fix the PATH and GEM_PATH for the web server
# (can't see how to configure foreman to access chruby from upstart)
# https://github.com/ddollar/foreman/wiki/Exporting-for-production
echo "PATH=$PATH" > /tmp/foreman.env
echo "GEM_PATH=$GEM_PATH" >> /tmp/foreman.env
cat .env >> /tmp/foreman.env
bundle exec foreman export upstart --env=/tmp/foreman.env --app=flippd --user=root /tmp

echo "Use upstart to ensure web server restarts on boot"
sudo mv /tmp/flippd*.conf /etc/init

sudo start flippd
