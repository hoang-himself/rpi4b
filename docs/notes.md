# Random notes

## Generate systemd units for Podman

```shell
podman generate systemd --pod-prefix pod --container-prefix container --name name --files --new
```

## Set unprivileged port start

```shell
sudo tee '/etc/sysctl.d/50-rootless-port.conf' <<<'net.ipv4.ip_unprivileged_port_start = 22' >/dev/null
sudo sysctl --system >/dev/null
```
