#!/usr/bin/env bash

podman run -d --replace -p 51820:51820/udp --name wireguard \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=UTC \
  -e SERVERURL=auto \
  -e SERVERPORT=51820 \
  -e PEERS=3 \
  -e PEERDNS=auto \
  -e INTERNAL_SUBNET=192.168.0.0 \
  -v '/opt/wireguard-server/config:/config:Z' \
  -v '/lib/modules:/lib/modules:Z' \
  --sysctl net.ipv4.conf.all.src_valid_mark=1 \
  lscr.io/linuxserver/wireguard:latest
