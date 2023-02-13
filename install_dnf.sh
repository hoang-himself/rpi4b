#!/usr/bin/env bash

function install_base {
  sudo dnf install -y openssh-server nss-mdns avahi
  sudo systemctl enable --now avahi-daemon.service
}

function install_vcgencmd {
  sudo dnf install -y cmake gcc gcc-c++ make git

  create-tmp
  git clone --depth 1 https://github.com/raspberrypi/userland.git && cd userland || exit
  ./buildme --aarch64
  clear-tmp

  sudo tee '/etc/ld.so.conf.d/vcgencmd.conf' <<<'/opt/vc/lib' >/dev/null
  sudo ldconfig
  echo 'export PATH=/opt/vc/bin:$PATH' >"$ZDOTDIR/zshrc.d/99-vcgencmd.rc.zsh"

  sudo tee /etc/udev/rules.d/99-local-vchiq-permissions.rules <<<'KERNEL=="vchiq",GROUP="video",MODE="0660"' >/dev/null
  sudo udevadm trigger /dev/vchiq
  sudo usermod -aG video $USER
}

function set_firewall {
  sudo firewall-cmd --permanent --add-service ssh
  sudo firewall-cmd --permanent --add-service mdns
  sudo firewall-cmd --permanent --add-service http
  sudo firewall-cmd --permanent --add-service https
  sudo firewall-cmd --permanent --add-service http3
}
