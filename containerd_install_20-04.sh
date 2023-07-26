function containerd_install_20-04(){

# configuration file creation for containerd
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF


        # loading overlay and br_netfilter modules
        sudo modprobe overlay
        sudo modprobe br_netfilter

        # containterd installation
        sudo apt-get update && sudo apt-get install -y containerd.io

        # the default configuration file for containerd
        sudo mkdir -p /etc/containerd

        # Generate the default containerd configuration, and save it to the newly created default file
        sudo containerd config default | sudo tee /etc/containerd/config.toml

        # Restart containerd to ensure the new configuration file is used
        sudo systemctl restart containerd

}

function main(){

	containerd_install_20-04

}

main
