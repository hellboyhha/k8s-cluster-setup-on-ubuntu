#  install Calico Networking
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

# Check the status of the control plane node
kubectl get nodes
