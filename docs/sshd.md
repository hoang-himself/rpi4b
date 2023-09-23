# Changing SSHd port

1. Change `sshd` configs in `/etc/ssh` (remember to restart `sshd` service)
2. Update `SELinux` configs (if applicable)

    ```shell
    semanage port -a -t ssh_port_t -p tcp 69420
    ```

3. Open the port on the firewall
    1. `ufw`
        ```shell
        ufw allow 69420 comment 'sshd'
        ```

    2. `firewalld`

        ```shell
        firewall-cmd --permanent --service=ssh --add-port 69420/tcp
        #firewall-cmd --permanent --add-port=69420/tcp
        firewall-cmd --reload
        ```
