k8s_version='1.27.0-00'

function k8s_install(){

# configuration file creation for k8s-networking
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

        # apply the new configuration
        sudo sysctl --system

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
        sudo apt-get update -y

        # Install Kubernetes packages
        sudo apt-get install -y kubelet=$k8s_version kubeadm=$k8s_version kubectl=$k8s_version --allow-change-held-packages

	# Turn off automatic updates
	sudo apt-mark hold kubelet kubeadm kubectl

}

function main(){

	k8s_install

}

main
