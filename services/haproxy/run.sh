#!/usr/bin/env bash

HAPROXY_REMOTE_IMAGE=${HAPROXY_REMOTE_IMAGE:-'docker.io/library/haproxy:latest'}
HAPROXY_CONFIG_DIR=${HAPROXY_CONFIG_DIR:-'/usr/local/etc/haproxy'}
HAPROXY_PODMAN_CONTAINER=${HAPROXY_PODMAN_CONTAINER:-'haproxy'}
CERT_DIR=${CERT_DIR:-"$HOME/porkbun/certbun/certs"}

podman run -d --replace -p 80:80 -p 443:443 --name "$HAPROXY_PODMAN_CONTAINER" \
  -v "$PWD/haproxy.cfg:$HAPROXY_CONFIG_DIR/haproxy.cfg:Z" \
  -v "$CERT_DIR/domain.cert.pem:$HAPROXY_CONFIG_DIR/certs/site.pem:Z" \
  -v "$CERT_DIR/private.key.pem:$HAPROXY_CONFIG_DIR/certs/site.pem.key:Z" \
  --sysctl net.ipv4.ip_unprivileged_port_start=80 \
  "$HAPROXY_REMOTE_IMAGE"
