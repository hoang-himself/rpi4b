# Prepare a Fedora image for headless installation

1. Download raw image and decompress
2. Mount file system

   ```shell
   sudo kpartx -av Fedora-Server.aarch64.raw
   sudo mkdir -p /mnt/raw3
   sudo mount /dev/fedora/root /mnt/raw3

   sudo dnf install qemu-user-static
   sudo systemctl restart systemd-binfmt
   ```

3. Prepare the image

   ```shell
   sudo chroot /mnt/raw3 /bin/bash

   hostname raspberrypi.local
   groupadd -g 1000 pi
   useradd -g pi -G wheel -m -u 1000 pi
   # change your password  with `passwd pi`

   mkdir -p /home/pi/.ssh
   touch /home/pi/.ssh/authorized_keys
   # add your public ssh key to the `authorized_keys` file
   chmod 700 /home/pi/.ssh
   chmod 600 /home/pi/.ssh/authorized_keys
   chown -R pi:pi /home/pi

   echo "%wheel ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers.d/wheel-nopasswd
   unlink /etc/systemd/system/multi-user.target.wants/initial-setup.service
   unlink /etc/systemd/system/graphical.target.wants/initial-setup.service

   # Tweak dnf download speed
   echo 'max_parallel_download=16' >>/etc/dnf/dnf.conf
   echo 'fastestmirror=True' >>/etc/dnf/dnf.conf

   exit
   ```

4. Repack the image

   ```shell
   sudo umount /mnt/raw3
   sudo pvscan
   sudo vgchange --activate n fedora
   sudo kpartx -d Fedora-Server.aarch64.raw
   ```

5. Compress as `xz` and you're done
