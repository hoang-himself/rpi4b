# Setting a static IP address

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

## `NetworkManager`

To add a connection with static IPv4 configuration:

```shell
nmcli connection add type ethernet ifname INTERFACE con-name NAME ip4 ADDRESS gw4 GATEWAY -- +ipv4.dns DNS
nmcli connection up NAME
```

IPv6 information can be added by replacing `4` with `6`.
