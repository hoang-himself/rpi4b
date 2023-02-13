function get-temp {
  if [[ -x "$(command -v vcgencmd)" ]]; then
    vcgencmd measure_temp
  else
    cat /sys/devices/virtual/thermal/thermal_zone0/temp
  fi
}

function g-agent {
  rm -f "$(gpgconf --list-dirs agent-socket)"
  logout
}
