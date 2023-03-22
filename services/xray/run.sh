#!/usr/bin/env bash

podman run -d --replace -p 80:80 --name xray \
  -v "$PWD/config.json:/etc/xray/config.json:Z" \
  docker.io/teddysun/xray:latest
