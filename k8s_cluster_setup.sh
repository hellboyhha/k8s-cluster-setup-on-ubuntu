#!/bin/bash

function worker_join_token_creation(){

        # create the token for worker nodes
        kubeadm token create --print-join-command
}

function main(){

	echo  -e "\n***** Welcome to K8S cluster setup *****\n"

	while [[ $ubuntu_version != "20-04" && $ubuntu_version != "22-04" ]]; do
    		read -p "Please choose your ubuntu version (20-04 or 22-04):" ubuntu_version
	done

	# clean up
	echo -e "\n***** Old Packages & Files Clean up in Master Node *****\n"
	sleep 5
	./cleanup_old_packages_files.sh
	sleep 3


	echo -e "\n***** Containerd installation on ubuntu_$ubuntu_version in Master Node *****\n"
	sleep 5
	./containerd_install_$ubuntu_version.sh
	sleep 3


	echo -e "\n***** K8S installation in Master Node *****\n"
	sleep 5
	./k8s_install.sh
	sleep 3

	echo -e "\n***** Control plane Setup in Master Node *****\n"
	sleep 5
	./control_plane_setup.sh
	sleep 3

	worker_join_command=$(worker_join_token_creation)

	while [[ $worker_join != "N" && $worker_join != "n" ]]; do
                read -rep $'\nPlease enter your workernode username:' workernode_username
		read -p "Please enter your workernode ip:" workernode_ip

		echo -e "\n***** Worker Setup at $workernode_ip *****\n"
		sleep 5
		./worker_node_join.sh "$workernode_username" "$workernode_ip" "$ubuntu_version"
		sleep 3
		
		echo -e "\n***** Worker Node Join from $workernode_username in $workernode_ip. Please, provide the password of $workernode_username in $workernode_ip. *****\n"
		sleep 5
		ssh -t $workernode_username@$workernode_ip "sudo $worker_join_command"
		sleep 3

		# check status of k8s-cluster
        	echo -e "\n***** Cluster Status *****\n"
        	sleep 3
       	 	kubectl get nodes

		read -rep $'\nDo you want to join another worker node (Y/y/N/n):' worker_join
        done

}

main


