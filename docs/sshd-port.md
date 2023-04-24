# Changing SSHd port

1. Change `sshd` configs in `/etc/ssh` (remember to restart `sshd` service)
2. Update `SELinux` configs (if applicable)

    ```shell
    sudo semanage port -a -t ssh_port_t -p tcp 69420
    ```

3. Open the port on the firewall
    1. `ufw`: `/etc/default/ufw`, `/etc/ufw`

        ```shell
        sudo ufw allow 69420 comment 'sshd'
        ```

        `user.rules`:

        ```text
        *filter
        :ufw-user-input - [0:0]
        :ufw-user-output - [0:0]
        :ufw-user-forward - [0:0]
        :ufw-before-logging-input - [0:0]
        :ufw-before-logging-output - [0:0]
        :ufw-before-logging-forward - [0:0]
        :ufw-user-logging-input - [0:0]
        :ufw-user-logging-output - [0:0]
        :ufw-user-logging-forward - [0:0]
        :ufw-after-logging-input - [0:0]
        :ufw-after-logging-output - [0:0]
        :ufw-after-logging-forward - [0:0]
        :ufw-logging-deny - [0:0]
        :ufw-logging-allow - [0:0]
        ### RULES ###

        ### tuple ### allow any 69420 0.0.0.0/0 any 0.0.0.0/0 in comment=737368
        -A ufw-user-input -p tcp --dport 69420 -j ACCEPT
        -A ufw-user-input -p udp --dport 69420 -j ACCEPT

        ### END RULES ###

        ### LOGGING ###
        -A ufw-after-logging-input -j LOG --log-prefix "[UFW BLOCK] " -m limit --limit 3/min --limit-burst 10
        -A ufw-after-logging-forward -j LOG --log-prefix "[UFW BLOCK] " -m limit --limit 3/min --limit-burst 10
        -I ufw-logging-deny -m conntrack --ctstate INVALID -j RETURN -m limit --limit 3/min --limit-burst 10
        -A ufw-logging-deny -j LOG --log-prefix "[UFW BLOCK] " -m limit --limit 3/min --limit-burst 10
        -A ufw-logging-allow -j LOG --log-prefix "[UFW ALLOW] " -m limit --limit 3/min --limit-burst 10
        ### END LOGGING ###
        COMMIT
        ```

        `user6.rules`:

        ```text
        *filter
        :ufw6-user-input - [0:0]
        :ufw6-user-output - [0:0]
        :ufw6-user-forward - [0:0]
        :ufw6-before-logging-input - [0:0]
        :ufw6-before-logging-output - [0:0]
        :ufw6-before-logging-forward - [0:0]
        :ufw6-user-logging-input - [0:0]
        :ufw6-user-logging-output - [0:0]
        :ufw6-user-logging-forward - [0:0]
        :ufw6-after-logging-input - [0:0]
        :ufw6-after-logging-output - [0:0]
        :ufw6-after-logging-forward - [0:0]
        :ufw6-logging-deny - [0:0]
        :ufw6-logging-allow - [0:0]
        ### RULES ###

        ### tuple ### allow any 69420 ::/0 any ::/0 in comment=737368
        -A ufw6-user-input -p tcp --dport 69420 -j ACCEPT
        -A ufw6-user-input -p udp --dport 69420 -j ACCEPT

        ### END RULES ###

        ### LOGGING ###
        -A ufw6-after-logging-input -j LOG --log-prefix "[UFW BLOCK] " -m limit --limit 3/min --limit-burst 10
        -A ufw6-after-logging-forward -j LOG --log-prefix "[UFW BLOCK] " -m limit --limit 3/min --limit-burst 10
        -I ufw6-logging-deny -m conntrack --ctstate INVALID -j RETURN -m limit --limit 3/min --limit-burst 10
        -A ufw6-logging-deny -j LOG --log-prefix "[UFW BLOCK] " -m limit --limit 3/min --limit-burst 10
        -A ufw6-logging-allow -j LOG --log-prefix "[UFW ALLOW] " -m limit --limit 3/min --limit-burst 10
        ### END LOGGING ###
        COMMIT
        ```

    2. `firewalld`: `/usr/lib/firewalld`, `/etc/firewalld`

        ```shell
        sudo firewall-cmd --permanent --service=ssh --add-port 69420/tcp
        #sudo firewall-cmd --permanent --add-port=69420/tcp
        sudo firewall-cmd --reload
        ```

        `services/ssh.xml`:

        ```xml
        <?xml version="1.0" encoding="utf-8"?>
        <service>
          <short>SSH</short>
          <description>Secure Shell (SSH) is a protocol for logging into and executing commands on remote machines. It provides secure encrypted communications. If you plan on accessing your machine remotely via SSH over a firewalled interface, enable this option. You need the openssh-server package installed for this option to be useful.</description>
          <port port="22" protocol="tcp"/>
          <port port="69420" protocol="tcp"/>
        </service>
        ```

        `zones/FedoraServer.xml`:

        ```xml
        <?xml version="1.0" encoding="utf-8"?>
        <zone>
          <short>Public</short>
          <description>For use in public areas. You do not trust the other computers on networks to not harm your computer. Only selected incoming connections are accepted.</description>
          <service name="ssh"/>
          <service name="dhcpv6-client"/>
          <service name="cockpit"/>
          <service name="mdns"/>
          <port port="69420" protocol="tcp"/>
          <forward/>
        </zone>
        ```
