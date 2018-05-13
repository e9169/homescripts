#!/bin/bash
# Script created to add a new route to reach the raspberry pi from the local network while connected to the VPN

sudo ip route add 10.8.0.0/24 via 192.168.1.1
