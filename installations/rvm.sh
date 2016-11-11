#!/bin/sh
#
# Install RVM

if test ! $(which rvm)
then
  echo "Installing rvm"
  \curl -sSL https://get.rvm.io | bash
fi


source "/usr/local/rvm/bin/rvm"
rvm install ruby-2.1.7
rvm install ruby-2.2.3
rvm --default use ruby-2.1.7
gem install bundler rake rspec rails --no-rdoc --no-ri
rvm use ruby-2.2.3
gem install bundler rake rspec rails --no-rdoc --no-ri