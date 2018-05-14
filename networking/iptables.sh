#!/bin/bash

# Author: Eneko Perez
# Date: 2018

# The idea was to create a killswitch for the downloads machine (Raspberry Pi) in case the VPN connection was lost.
# This killswitch allows network (local) traffic

# Execute this script and then modify /etc/network/interfaces file this way for the network device:
# pre-up iptables-restore < /etc/iptables.rules
# pre-up ip6tables-restore < /etc/ip6tables.rules

# Flush
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X

# Flush V6
ip6tables -t nat -F
ip6tables -t mangle -F
ip6tables -F
ip6tables -X

# Allow Localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow Localhost V6
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT

# Local Local Network traffic
iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -j ACCEPT
iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -j ACCEPT

# ASUS Router VPN
iptables -A INPUT -s 10.8.0.0/24 -d 192.168.1.0/24 -j ACCEPT
iptables -A OUTPUT -s 192.168.1.0/24 -d 10.8.0.0/24 -j ACCEPT

# Allow incoming pings
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Allow established sessions to receive traffic
iptables -A INPUT -m state --state ESTABLISHED,RELATEd -j ACCEPT

# Allow TUN
iptables -A INPUT -i tun+ -j ACCEPT
iptables -A FORWARD -i tun+ -j ACCEPT
iptables -A OUTPUT -o tun+ -j ACCEPT

# Block All
iptables -A OUTPUT -j DROP
iptables -A INPUT -j DROP
iptables -A FORWARD -j DROP

# Block ALL V6
ip6tables -A OUTPUT -j DROP
ip6tables -A INPUT -j DROP
ip6tables -A FORWARD -j DROP

# Allow ports for PIA VPN connection. They could be different if using a different VPN provider.
# UDP Ports
iptables -I OUTPUT 1 -p udp --destination-port 1194 -m comment --comment "Allow VPN connection" -j ACCEPT
iptables -I OUTPUT 1 -p udp --destination-port 1197 -m comment --comment "Allow VPN connection" -j ACCEPT
iptables -I OUTPUT 1 -p udp --destination-port 1198 -m comment --comment "Allow VPN connection" -j ACCEPT
iptables -I OUTPUT 1 -p udp --destination-port 8080 -m comment --comment "Allow VPN connection" -j ACCEPT
iptables -I OUTPUT 1 -p udp --destination-port 9201 -m comment --comment "Allow VPN connection" -j ACCEPT

# DNS
iptables -I OUTPUT 1 -p udp --destination-port 53 -m comment --comment "Allow VPN connection (DNS)" -j ACCEPT

# TCP Ports
iptables -I OUTPUT 1 -p tcp --destination-port 502 -m comment --comment "Allow VPN connection" -j ACCEPT
iptables -I OUTPUT 1 -p tcp --destination-port 501 -m comment --comment "Allow VPN connection" -j ACCEPT
iptables -I OUTPUT 1 -p tcp --destination-port 443 -m comment --comment "Allow VPN connection (HTTPS)" -j ACCEPT
iptables -I OUTPUT 1 -p tcp --destination-port 110 -m comment --comment "Allow VPN connection (POP3)" -j ACCEPT
iptables -I OUTPUT 1 -p tcp --destination-port 80 -m comment --comment "Allow VPN connection (HTTP)" -j ACCEPT

echo "Saving"

iptables-save > /etc/iptables.rules
ip6tables-save > /etc/ip6tables.rules

echo "Done"
