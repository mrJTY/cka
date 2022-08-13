
sudo kubeadm init --config ./kubeadm-config.yaml

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl create -f https://projectcalico.docs.tigera.io/manifests/tigera-operator.yaml
kubectl create -f https://projectcalico.docs.tigera.io/manifests/custom-resources.yaml

sudo systemctl daemon-reload
sudo systemctl restart kubelet

# (Optional) Remove the taint on control plane to make it easy
# kubectl taint nodes --all node-role.kubernetes.io/master-