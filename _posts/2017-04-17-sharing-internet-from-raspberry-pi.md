---
layout: post
date: 2017-04-17T18:47:05Z
title: "Sharing internet from Raspberry Pi"
tags: raspberry-pi linux
---

The ADSL line is down. But you have a 3G modem/cellphone. The problem is you want (need?) internet on a desktop.

Getting internet on a cellphone or laptop is easy, you just need to create a hotspot on the (internet sharing) cellphone and connect to it. But how do you connect a wired-only desktop pc to it?
Of course there are a lot easier ways (like just using a WiFi dongle on the desktop) but this seemed like something fun to do.

### What you need

- A cellphone/3G modem that can share its internet over WiFi
- Raspberry Pi (or an old PC)
- WiFi dongle
- lan cables
- an internet connection before starting (installing packages)

#### Assumptions

- wireless lan interface is called `wlan0`
- ethernet on Raspberry Pi is `eth0`
- you are using WPA/WPA2 security
- ethernet on desktop pc is `enp0s25`
- you want to use `192.168.123.100/24` as the static ip for Raspberry Pi

#### Steps

- Connect to the internet on Raspberry Pi
- Setup internet sharing
- Connect to the internet through Raspberry Pi

### Connecting to the internet using a WiFi dongle on Raspberry Pi

Install Arch Linux on Raspberry Pi ([how to](https://archlinuxarm.org/platforms/armv6/raspberry-pi))

#### Device drivers

Install device drivers for the WiFi dongle if needed ([more details](https://wiki.archlinux.org/index.php/Wireless_network_configuration#Check_the_driver_status))

`dmesg | grep usbcore`

**note** when checking to see if the interface is up, look for `<...UP...>`, **not** the `state DOWN`

See if you can scan for the WiFi AP
```
ip link set wlan0 up
iw dev wlan0 scan | grep SSID
```

#### Connect

For WPA connections, install `wpa_supplicant` (use `pacman -U /var/cache/pacman/pkg/wpa_supplicant-....` to install from a already-downloaded package file)

Generate a config file for the WiFi access point that includes it's name (SSID) and password:

```
wpa_passphrase "wifi access point name" "password" > /etc/wpa_supplicant/name.conf
```

Then connect to the WiFi hotspot, check the details and obtain an ip address:

```
wpa_supplicant -D nl80211,wext -i wlan0 -c /etc/wpa_supplicant/name.conf -B
iw dev wlan0 link
dhcpcd wlan0
```

Test internet connectivity and DNS lookup:

```
ping 8.8.8.8 -c 4
ping www.google.com -c 4
```

#### Fixing DNS

I had an issue where the DNS was not resolved (but was able to ping). Fix the `/etc/nsswitch.conf` file to include `dns` by changing the

`hosts: files mymachines ...`

line to

`hosts: files dns mymachines ...`


### Setup internet sharing

Set a static ip address on the ethernet device, enable port forwarding on it and allow forwarding (NAT) from ethernet to WiFi:

```
ip addr add 192.168.123.100/24 dev eth0
sysctl net.ipv4.ip_forward=1

iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT
```

note: using `sysctl net.ipv4.conf.eth0.forwarding=1` to enable on specific interface only did not work.


### Using the shared internet connection on the Raspberry Pi

_Run these commands on the desktop pc._

#### Add a static ip address

Run the following to add a static ip address for the wired connection:

```
ip addr add 192.168.123.201/24 dev enp0s25
ip link set up dev enp0s25
ip route add default via 192.168.123.100 dev enp0s25
```

Had some issue with previously obtained ip address/route, so had to stop DHCP (`dhcpcd -k`) and flush the address and routes (`ip addr flush dev enp0s25 && ip route flush dev enp0s25`) before running these commands.

Check that you have internet: `ping 8.8.8.8 -c 4`

#### DNS

For now, just use a public DNS server (like Google's `8.8.8.8`) by editing `/etc/resolv.conf`:

```
nameserver 8.8.8.8
nameserver 8.8.4.4
```

Test using `ping www.google.com -c 4`


### Sources

- [Setting up wireless connection](https://wiki.archlinux.org/index.php/Wireless_network_configuration)
- [setting up internet sharing](https://wiki.archlinux.org/index.php/Internet_sharing)
- [general/client side](https://wiki.archlinux.org/index.php/Network_configuration#Manual_assignment)
