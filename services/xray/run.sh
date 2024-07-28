#!/usr/bin/env bash

podman container run -d --replace -p 80:80 --name xray \
  -v 'xray:/etc/xray' \
  -v "$PWD/config.json:/etc/xray/config.json:z" \
  docker.io/teddysun/xray:latest
