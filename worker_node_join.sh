#!/bin/bash

# copy required scripts to worker node
scp containerd_install_$3.sh k8s_install.sh $1@$2:/home/$1

# containerd installation on worker node
ssh -t $1@$2 "cd $HOME && ./containerd_install_$3.sh"

# k8s installation on worker node
ssh -t $1@$2 "cd $HOME && ./k8s_install.sh"

