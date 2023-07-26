#!/bin/bash

k8s_version='1.27.0'

function cluster_initialization(){

        # Initialization the Kubernetes cluster on the control plane node using kubeadm
        sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version $k8s_version

        # setting kubectl access
        mkdir -p $HOME/.kube
        sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config

        # testing access to the cluster
        kubectl get nodes

        # the Calico Network Add-On installatiion
        kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

        # checking the status of the control plane node
        kubectl get nodes

}

function main(){

        cluster_initialization

}

main
