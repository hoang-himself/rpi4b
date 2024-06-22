# Installing Fedora Server

This note makes a few assumptions:

- The name of the raw image file is `Fedora-Server.aarch64.raw`
- The group's name and ID are `pi` and `1000` respectively
- The user's name and ID are `pi` and `1000` respectively

## Preparing the installation image

### Download raw image and decompress

Make sure to download the `Raw image for aarch64` from [the download page](https://getfedora.org/en/server/download/)

### Mount the file system

```shell
kpartx -av Fedora-Server.aarch64.raw
mkdir -p /mnt/raw3
mount /dev/fedora/root /mnt/raw3

dnf install -y qemu-user-static
systemctl restart systemd-binfmt
```

### Prepare the image

Firstly, `chroot` to the mount to make the changes effective to the image

```shell
chroot /mnt/raw3 /bin/bash
```

#### Disable OOBE

```shell
unlink /etc/systemd/system/multi-user.target.wants/initial-setup.service
unlink /etc/systemd/system/graphical.target.wants/initial-setup.service
```

#### Enable mDNS

```shell
[[ -f /etc/systemd/resolved.conf ]] \
  && sed -i 's/#MulticastDNS=no/MulticastDNS=yes/' /etc/systemd/resolved.conf \
  || echo 'MulticastDNS=yes' >>/etc/systemd/resolved.conf
nmcli connection modify <NAME> +connection.mdns 2
```

#### Tweak `dnf` for faster downloads

```shell
echo 'max_parallel_downloads=16' >>/etc/dnf/dnf.conf
echo 'fastestmirror=True' >>/etc/dnf/dnf.conf
```

#### Users and groups

```shell
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers.d/wheel-nopasswd
groupadd -g 1000 pi

# Initially the user has no password to be logged in with
# If you skip -p, you must add an ssh key to login
useradd -g pi -G wheel -m -u 1000 -p <password> pi
```

#### Setting authorized SSH keys

```shell
mkdir -p /home/pi/.ssh
touch /home/pi/.ssh/authorized_keys # add your public key to this file
chmod 700 /home/pi/.ssh
chmod 600 /home/pi/.ssh/authorized_keys
```

#### Permissions

This step has to be performed last

```shell
chown -R pi:pi /home/pi
exit
```

### Unmount the file system

```shell
umount /mnt/raw3
pvscan
vgchange --activate n fedora
kpartx -d Fedora-Server.aarch64.raw
```

### Repack the image

Compress as `xz` using your favorite tool, then use [Raspberry Pi Imager](https://www.raspberrypi.com/software/) or equivalent tools to write the image to your medium

## Post-installation configurations

These tasks cannot be performed during the [preparation step](#preparing-the-installation-image) due to various reasons

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
