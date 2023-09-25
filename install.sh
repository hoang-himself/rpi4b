#!/usr/bin/env bash
if [[ $EUID -eq 0 ]]; then
  echo 'Run script without sudoer'
  exit 1
fi

if [[ -x "$(command -v apt)" ]]; then
  . ./install_apt.sh
elif [[ -x "$(command -v dnf)" ]]; then
  . ./install_dnf.sh
fi

function set_openssh {
  for rc in ./configs/sshd_config.d/*.conf; do
    [[ -f "$rc" ]] && sudo ln -frs "$rc" "/etc/ssh/sshd_config.d/$(basename "$rc")"
  done
  for rc in ./configs/ssh_config.d/*.conf; do
    [[ -f "$rc" ]] && ln -frs "$rc" "$HOME/.ssh/config.d/$(basename "$rc")"
  done
  ln -frs ./configs/sshrc "$HOME/.ssh/rc"
}

function set_runcom {
  for rc in ./runcoms/*; do
    [[ -f "$rc" ]] && ln -frs "$rc" "$ZDOTDIR/zshrc.d/$(basename "$rc")"
  done
}

function set_unprivileged_port_start {
  sudo tee '/etc/sysctl.d/50-rootless-port.conf' <<<'net.ipv4.ip_unprivileged_port_start = 22' >/dev/null
  sudo sysctl --system >/dev/null
}

function enable_passwdless_sudo {
  sudo tee "/etc/sudoers.d/00-$(whoami)" <<<"$(whoami) ALL=(ALL) NOPASSWD: ALL" >/dev/null
  sudo chmod 0440 "/etc/sudoers.d/00-$(whoami)"
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
  set_runcom
  set_firewall
  set_unprivileged_port_start
}

main
