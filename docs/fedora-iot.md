# Installing Fedora IoT on RPi4

## Installing Fedora IoT

The following command will wipe and write Fedora IoT with a nologin root account:

```shell
arm-image-installer \
  --image Fedora-IoT.aarch64.raw.xz --target rpi4 \
  --media /dev/mmcblk0 --resizefs \
  --addkey .ssh/id_ed25519.pub --norootpass
```

where:

- `image` is the path to the raw image
- `media` is the path to the storage device, can be obtained with `lsblk`
- `addkey` is the path to an SSH public key

## Post-installation configurations

The device can only be logged in via SSH using the configured key

### Users and groups

```shell
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers.d/wheel-nopasswd
groupadd -g 1000 pi

# useradd expects a hashed password, but mkpasswd is not available
useradd -g pi -G wheel -m -u 1000 pi
passwd pi

# Copy the pre-configured SSH key
mkdir -p /var/home/pi/.ssh
cp /root/.ssh/authorized_keys /var/home/pi/.ssh/authorized_keys
chmod 700 /var/home/pi/.ssh
chmod 600 /var/home/pi/.ssh/authorized_keys
chown -R pi:pi /var/home/pi
```

#### Enable mDNS

```shell
rpm-ostree install avahi nss-mdns
nmcli connection modify <NAME> +connection.mdns 2
```

### Setting hostname (pretty, static, transient)

```shell
hostnamectl hostname raspberrypi.local
```

### Setting timezone

Since this is a server image, it is recommended to set the timezone to UTC

If your applications require a different time zone, in most cases, it is possible to set a different time zone than the system one for individual applications by setting the `TZ` environment variable

```shell
timedatectl set-timezone UTC
timedatectl set-local-rtc no
```

### Disabling unneeded service

```shell
for service in zezere_ignition.timer zezere_ignition zezere_ignition_banner; do
  sudo systemctl stop $service
  sudo systemctl disable $service
  sudo systemctl mask $service
done
```
