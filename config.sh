#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# update packages
apt update
apt upgrade -y
apt autoremove -y

# allow ssh password autientication
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
systemctl restart ssh

# turn off swapping (disabled default on vagrant ubuntu/jammy64(22.04) box)
# swapoff -a

# # load br_netfilter module
# modprobe br_netfilter
# # create configuration files for kernel parameters
# cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
# br_netfilter
# EOF
# cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
# net.bridge.bridge-nf-call-ip6tables = 1
# net.bridge.bridge-nf-call-iptables = 1
# EOF
# # load settings from configuration files
# sysctl --system

# enable ipv4 packet forwarding
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
# apply sysctl without reboot
sysctl --system

# # configure /etc/hosts file
echo "${2} k8s-cp" >>/etc/hosts
for ((i = 1; i <= $1; i++)); do echo "192.168.2.2${i} k8s-w${i}" >>/etc/hosts; done
