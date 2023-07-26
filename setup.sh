
function worker_join_token_creation(){

        # create the token for worker nodes
        kubeadm token create --print-join-command
}

function main(){

	echo "***** Welcome to K8S cluster setup *****"

	while [[ $ubuntu_version != "20-04" && $ubuntu_version != "22-04" ]]; do
    		read -p "Please choose your ubuntu version (20-04 or 22-04):" ubuntu_version
	done

	echo "***** Containerd installation on ubuntu_$ubuntu_version *****"
	./containerd_install_$ubuntu_version.sh
	sleep 5

	echo "***** K8S installation *****"
	./k8s_install.sh
	sleep 5

	echo "***** Control plane Setup *****"
	./control-plane-setup.sh

	worker_join_command=$(worker_join_token_creation)

	while [[ $worker_join != "N" && $worker_join != "n" ]]; do
                read -p "Please enter your workernode username:" workernode_username
		read -p "Please enter your workernode ip:" workernode_ip

		echo "***** Worker Node Join from $workernode_username at $workernode_ip *****"
		./worker_node_join.sh "$workernode_username" "$workernode_ip" "$ubuntu_version"
		
		ssh -t $workernode_username@$workernode_ip "sudo $worker_join_command"

		read -p "Do you want to join another worker node (Y/y/N/n):" worker_join
        done

	# check status of k8s-cluster
	kubectl get nodes

}

main


