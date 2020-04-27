#!/bin/bash

pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash -c "\
  sudo rm -rf /tmp/ubuntu-perfect-install \
  && sudo apt install -y git \
  && git clone https://github.com/thiagotognoli/ubuntu-perfect-install.git /tmp/ubuntu-perfect-install \
  && sudo bash /tmp/ubuntu-perfect-install/run.sh;
  sudo rm -rf /tmp/ubuntu-perfect-install
"
#wget https://github.com/thiagotognoli/ubuntu-perfect-install/archive/master.zip