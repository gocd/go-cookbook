#!/bin/bash

wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.9.0-1_amd64.deb -qc
sudo dpkg -i chefdk_0.9.0-1_amd64.deb
export PATH=/opt/chefdk/bin:/opt/chefdk/embedded/bin:$PATH
sudo $(which chef) gem install kitchen-docker
