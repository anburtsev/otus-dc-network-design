Настройки приводятся только для Host1. Остальные хосты настраиваются аналогично, изменяя только имя хоста и соответсвующие IP адреса.

1. Изменить имя хоста:

`hostnamectl set-hostname host1`

1. Настроить сеть на хосте:
Редактируем файлы:

`/etc/network/interfases`
```
allow-hotplug ens3
auto ens3
iface ens3 inet static
 address 10.11.3.2/30
 post-up ip route add 10.11.0.0/16 via 10.11.3.1
 
allow-hotplug ens4 manual
auto ens4
iface ens4 inet 

allow-hotplug ens5
auto ens5
iface ens5 inet manual
```

`/etc/network/interfases.d/vxlan`
```
auto vxlan10101
iface vxlan10101
  vxlan-id 10101
  vxlan-local-tunnelip 10.11.3.2
  bridge-learning off
  bridge-arp-nd-suppress on
  
auto vxlan10102
iface vxlan10102
  vxlan-id 10102
  vxlan-local-tunnelip 10.11.3.2
  bridge-learning off
  bridge-arp-nd-suppress on

auto vxlan10201
iface vxlan10201
  vxlan-id 10201
  vxlan-local-tunnelip 10.11.3.2
  bridge-learning off
  bridge-arp-nd-suppress on
```
`/etc/network/interfases.d/bridge`
```
auto br10101
iface br10101
 bridge_ports vxlan10101 ens4
 bridge_stp off
 bridge_fd 0

auto br10102
iface br10102
 bridge_ports vxlan10102 ens4
 bridge_stp off
 bridge_fd 0

auto br10201
iface br10201
 bridge_ports vxlan10201 ens4
 bridge_stp off
 bridge_fd 0
```

перестартовываем сеть и FRR

`systemctl restart networking frr`

3. Настраиваем BGP в FRR
Подключаемся в vtysh и вводим конфигурацию BGP:
```
router bgp 4259840011
 bgp router-id 10.11.3.2
 neighbor SPINES peer-group
 neighbor SPINES remote-as internal
 neighbor SPINES update-source 10.11.3.2
 neighbor SPINES password otus
 neighbor 10.11.1.1 peer-group SPINES
 address-family ipv4 unicast
  no neighbor SPINES activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor SPINES activate
  advertise-all-vni
  vni 10101
    rd 10.11.3.2:10101
    route-target import 11:10101
    route-target export 11:10101
  exit-vni
  vni 10102
    rd 10.11.3.2:10102
    route-target import 11:10102
    route-target export 11:10102
  exit-vni
  vni 10201
    rd 10.11.3.2:10201
    route-target import 11:10201
    route-target export 11:10201
  exit-vni
  advertise ipv4 unicast
 exit-address-family
!
```