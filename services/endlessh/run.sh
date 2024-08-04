#!/usr/bin/env bash

podman container run -d --replace \
  --name endlessh \
  -p 2112:2112 \
  -p 22:2222 \
  docker.io/shizunge/endlessh-go:latest
