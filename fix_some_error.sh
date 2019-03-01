#!/usr/bin/env bash

#解决E: Sub-process /usr/bin/dpkg returned an error code (1)
sudo mv /var/lib/dpkg/info /var/lib/dpkg/info.bak
sudo mkdir /var/lib/dpkg/info
sudo apt-get update
