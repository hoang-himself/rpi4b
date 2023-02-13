#!/usr/bin/env bash

function install_base {
  sudo apt install -y openssh-server ufw
}

function set_firewall {
  sudo ufw limit 22 comment 'ssh'
  sudo ufw enable <<EOF
y
EOF
}
