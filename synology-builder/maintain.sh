#!/usr/bin/env bash

# This is meant to run every time the vagrant machine is up, so try to keep 
# installs away from this script - and focus on updates and maintaining instead.

echo "  ================================================================="
echo "                   Updating System & Distribution"
echo "  ================================================================="
echo
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get autoremove
sudo apt-get autoclean
echo