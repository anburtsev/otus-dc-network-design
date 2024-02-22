#!/bin/bash

if [ `id -u` -ne 0 ]; then
	echo Need sudo
	exit 1
fi
set -v

# Update all
apt update && apt -y upgrade && apt -y autoremove && apt clean

# set hostname to localhost
hostnamectl set-hostname localhost

# Stop services for cleanup
systemctl stop rsyslog

# Clear audit logs
if [ -f /var/log/audit/audit.log ]; then
    cat /dev/null > /var/log/audit/audit.log
fi
if [ -f /var/log/wtmp ]; then
    cat /dev/null > /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
    cat /dev/null > /var/log/lastlog
fi

# Cleanup persistent udev rules
if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
    rm /etc/udev/rules.d/70-persistent-net.rules
fi

# Cleanup DHCP leaseas
rm -f /var/lib/dhcp/dhclient.*

#clear machine-id
truncate -s0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# Cleanup /tmp directories
rm -rf /tmp/*
rm -rf /var/tmp/*

# Cleanup current ssh keys
#rm -f /etc/ssh/ssh_host_*

# Cleanup shell history
cat /dev/null > ~/.bash_history && history -c
history -w

# cleanup apt
apt clean

# shutdown
shutdown -h now
