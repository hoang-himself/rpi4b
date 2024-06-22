# Setting a static IP address

## `NetworkManager`

To add a connection with static IPv4 configuration:

```shell
nmcli connection add type ethernet ifname <INTERFACE> con-name <NAME> ip4 <ADDRESS> gw4 <GATEWAY> -- +ipv4.dns <DNS>
nmcli connection up <NAME>
```

where:

- `<INTERFACE>` can be obtained with `nmcli device`
- Relevant IPv6 configurations can be added by replacing `4` with `6`

## `dhcpcd`

Append the following lines to `/etc/dhcpcd.conf`, update the CAPITALIZED words accordingly:

```text
interface INTERFACE
static ip_address=ADDRESS/24
static routers=GATEWAY
static domain_name_servers=DNS
```

On the last line, `static` may be substituted with `inform`:

- `inform`: If the requested IP address is already in use, the computer will choose another address
- `static`: If the requested IP address is already in use, the computer will have no IP address at all
