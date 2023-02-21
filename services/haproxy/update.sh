#!/usr/bin/env bash

HAPROXY_PODMAN_CONTAINER=${HAPROXY_PODMAN_CONTAINER:-'haproxy'}

if podman container exists "$HAPROXY_PODMAN_CONTAINER"; then
 podman kill -s SIGHUP "$HAPROXY_PODMAN_CONTAINER"
 exit 0
fi

exit 1
