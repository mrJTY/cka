
sudo kubeadm init --config ./kubeadm-config.yaml

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f ./calico.yaml

sudo systemctl daemon-reload
sudo systemctl restart kubelet
