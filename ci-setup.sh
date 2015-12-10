#!/bin/bash

wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.10.0-1_amd64.deb -qc -O "${HOME}/.chefdk_0.10.0-1_amd64.deb"
sudo dpkg -i "${HOME}/.chefdk_0.10.0-1_amd64.deb"
eval "$(chef shell-init bash)"
sudo $(which chef) gem install bundler
sudo $(which chef) exec bundle install
