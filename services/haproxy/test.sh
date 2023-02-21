#!/usr/bin/env bash

HAPROXY_REMOTE_IMAGE=${HAPROXY_REMOTE_IMAGE:-'docker.io/library/haproxy:latest'}
HAPROXY_CONFIG_DIR=${HAPROXY_CONFIG_DIR:-'/usr/local/etc/haproxy'}
HAPROXY_BUILDAH_CONTAINER=${HAPROXY_BUILDAH_CONTAINER:-'haproxy-working-container'}
CERT_DIR=${CERT_DIR:-"$HOME/porkbun/certbun/certs"}

buildah from --name "$HAPROXY_BUILDAH_CONTAINER" "$HAPROXY_REMOTE_IMAGE"
buildah copy "$HAPROXY_BUILDAH_CONTAINER" 'haproxy.cfg' "$HAPROXY_CONFIG_DIR/haproxy.cfg"
buildah copy "$HAPROXY_BUILDAH_CONTAINER" "$CERT_DIR/domain.cert.pem" "$HAPROXY_CONFIG_DIR/certs/site.pem"
buildah copy "$HAPROXY_BUILDAH_CONTAINER" "$CERT_DIR/private.key.pem" "$HAPROXY_CONFIG_DIR/certs/site.pem.key"
buildah run "$HAPROXY_BUILDAH_CONTAINER" -- 'haproxy' '-c' '-f' "$HAPROXY_CONFIG_DIR/haproxy.cfg"
buildah rm "$HAPROXY_BUILDAH_CONTAINER"
