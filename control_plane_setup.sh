
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

	echo -e "\n**** Calico Network Add-on Installation at Master Node *****\n"
	sleep 5
        kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
	sleep 3

	# check status of k8s-cluster
        echo -e "\n***** Cluster Status *****\n"
        sleep 3
        kubectl get nodes	
}

function main(){

        cluster_initialization

}

main
