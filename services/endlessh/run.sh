#!/usr/bin/env bash

podman run -d --replace -p 22:2222 --name endlessh \
  -e PUID=1000 -e PGID=1000 -e TZ=UTC -e MSDELAY=10000 \
  -e MAXLINES=32 -e MAXCLIENTS=4096 -e LOGFILE=false \
  lscr.io/linuxserver/endlessh:latest