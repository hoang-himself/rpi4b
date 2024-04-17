#!/usr/bin/env bash
if [[ $EUID -eq 0 ]]; then
  echo 'Run script without sudoer'
  exit 1
fi

if ! command -v apt &>/dev/null; then
  echo 'apt not found'
  exit 1
fi

#shellcheck source=./common.sh
. ./common.sh

function install_base {
  sudo apt install -y openssh-server
}

function set_firewall {
  sudo ufw limit 22 comment 'ssh'
  sudo ufw enable <<EOF
y
EOF
}

function main {
  install_base
  set_openssh
  set_runcom
}

main
