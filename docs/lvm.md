# Extend Linux LVM partition size

Partition -> Physical volume -> Volume group -> Logical volume -> File system

```shell
sudo pvresize /dev/sda3
sudo lvextend -l +100%FREE /dev/fedora/root
sudo xfs_growfs /dev/fedora/root
```
