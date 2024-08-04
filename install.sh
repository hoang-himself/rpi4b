#!/usr/bin/env bash
function install_base {
  sudo rpm-ostree install avahi buildah git git-lfs neovim nss-mdns qemu-user-static
}

function set_openssh {
  for rc in ./configs/sshd_config.d/*.conf; do
    [[ -f "$item" ]] && sudo ln -frs "$item" "/etc/ssh/sshd_config.d/$(basename "$item")"
  done
  for rc in ./configs/ssh_config.d/*.conf; do
    [[ -f "$item" ]] && ln -frs "$item" "$HOME/.ssh/config.d/$(basename "$item")"
  done
  ln -frs ./runcoms/sshrc "$HOME/.ssh/rc"
}

function set_containers {
  for item in ./configs/containers/*/; do
    ln -frs "$item" "$XDG_CONFIG_HOME/containers/$(basename "$item")"
  done
  systemctl --user daemon-reload
}

function set_firewall {
  sudo firewall-cmd --permanent --add-service ssh
  sudo firewall-cmd --permanent --add-service mdns
  sudo firewall-cmd --permanent --add-service http
  sudo firewall-cmd --permanent --add-service https
  sudo firewall-cmd --permanent --add-service http3
  sudo firewall-cmd --reload
}

function repair_locale {
  sudo sed -i "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" -i /etc/locale.gen
  sudo locale-gen en_US.UTF-8
  sudo update-locale en_US.UTF-8

  export LANGUAGE=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
}

function main {
  install_base
  set_openssh
  set_containers
}

main
