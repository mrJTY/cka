
sudo kubeadm init --config ./kubeadm-config.yaml

mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install a CNI

# Weaveworks
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# Calico is pretty bad, buggy as of 2022
# kubectl create -f https://projectcalico.docs.tigera.io/manifests/tigera-operator.yaml
# kubectl create -f https://projectcalico.docs.tigera.io/manifests/custom-resources.yaml

sudo systemctl daemon-reload
sudo systemctl restart kubelet

# (Optional) Remove the taint on control plane to make it easy to develop
# kubectl taint nodes --all node-role.kubernetes.io/master-