#!/usr/bin/env bash

podman container run -d --replace -p 5000:5000 --name registry \
  -v "$PWD/config.yml:/etc/docker/registry/config.yml:z" \
  -v 'registry:/var/lib/registry' \
  docker.io/library/registry:latest
