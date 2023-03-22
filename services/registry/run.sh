#!/usr/bin/env bash

podman run -d --replace --pod dotfiles --name registry \
  -v "$PWD/config.yml:/etc/docker/registry/config.yml:Z" \
  -v registry:/var/lib/registry \
  docker.io/library/registry:latest
