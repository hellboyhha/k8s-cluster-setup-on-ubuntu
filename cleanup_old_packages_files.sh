#!/bin/bash

function cleanup(){

	# node clean up
	sudo kubeadm reset --force

	# purge installed old packages
	sudo apt-get purge -y --auto-remove  --allow-change-held-packages kubeadm kubectl kubelet kubernetes-cni kube*

	# remove old kubeconfigs
	sudo rm -rf ~/.kube

	# containerd clean up
        sudo apt-get purge -y --auto-remove containerd.io

}

function main(){

	cleanup

}

main



