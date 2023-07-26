function containerd_install_22-04(){

# configuration file creation for containerd
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF


        # Loading overlay and br_netfilter modules
        sudo modprobe overlay
        sudo modprobe br_netfilter

        # Dependencies installation
        sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg lsb-release

        # Download and add the GPG key to install containerd
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

        # Add the repository to the system
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

        # Containerd installation
        sudo apt-get update && sudo apt install -y containerd.io

        # the default configuration file for containerd
        sudo mkdir -p /etc/containerd

        # Generate the default containerd configuration, and save it to the newly created default file
        sudo containerd config default | sudo tee /etc/containerd/config.toml

        # Restart containerd to ensure the new configuration file is used
        sudo systemctl restart containerd

}

function main(){

	containerd_install_22-04

}

main
