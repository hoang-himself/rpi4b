#!/usr/bin/env bash

podman run -d --replace -p 5000:5000 --name registry \
  -v "$PWD/config.yml:/etc/docker/registry/config.yml:Z" \
  -v registry:/var/lib/registry \
  docker.io/library/registry:latest
