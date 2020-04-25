#!/bin/bash

pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash -c "\
cd /tmp \
  && sudo apt install -y git \
  && git clone https://github.com/thiagotognoli/ubuntu-perfect-install.git \
  && cd ubuntu-perfect-install \
  && sudo ./run.sh \
  && cd ~ \
  && rm -rf /tmp/ubuntu-perfect-install\
"
