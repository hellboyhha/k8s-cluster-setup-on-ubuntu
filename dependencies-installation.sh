#!/bin/bash

# configuration file for containerd
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

# loading modules
sudo modprobe overlay
sudo modprobe br_netfilter

# configuration file for k8s-networking
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# apply the new configuration
sudo sysctl --system

# containterd installation
sudo apt-get update && sudo apt-get install -y containerd.io

# the default configuration file for containerd
sudo mkdir -p /etc/containerd

# Generate the default containerd configuration, and save it to the newly created default file
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Restart containerd to ensure the new configuration file is used
sudo systemctl restart containerd

# disable the swap
sudo swapoff -a

# Install the dependency packages
sudo apt-get update && sudo apt-get install -y apt-transport-https curl

# Download and add the GPG key to install K8S
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add Kubernetes to the repository list
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# update the package listings
sudo apt-get update

# Install Kubernetes packages
sudo apt-get install -y kubelet=1.27.0-00 kubeadm=1.27.0-00 kubectl=1.27.0-00

# Turn off automatic updates
sudo apt-mark hold kubelet kubeadm kubectl
