# Files that can go in the `boot` partition

[Setting up a Headless Raspberry Pi](https://www.raspberrypi.com/documentation/computers/configuration.html#setting-up-a-headless-raspberry-pi)

## Configuring wireless networks

`wpa_supplicant.conf`

```text
country=VN
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
ap_scan=1

update_config=1
network={
  ssid="<Name of your wireless LAN>"
  psk="<Password for your wireless LAN>"
}
```

Generate the `network` dict using `wpa_passphrase`

```bash
wpa_passphrase mynetwork mypassword
```

## Configuring a user

`userconf.txt`

This file should contain a single line of text

```text
username:encrypted_password
```

To generate the encrypted password, the easiest way is to use OpenSSL on a Raspberry Pi that is already running

```bash
echo 'mypassword' | openssl passwd -6 -stdin
```

## Post-installation configurations

### Networking

Append these lines to `/etc/dhcpcd.conf`:

```text
interface <INTERFACE>
static ip_address=<ADDRESS>/24
static routers=<GATEWAY>
static domain_name_servers=<DNS>
```

At `domain_name_servers`, `static` may be substituted with `inform`:

- `inform`: If the requested IP address is already in use, the computer will choose another address
- `static`: If the requested IP address is already in use, the computer will have no IP address at all
