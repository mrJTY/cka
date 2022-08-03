Source: https://medium.com/swlh/setup-own-kubernetes-cluster-via-virtualbox-99a82605bfcc


```
nix-shell .

vagrant up
```

# init the control plane

```sh
vagrant ssh k8s-cp

kubeadm init \
    --apiserver-advertise-address 192.168.33.13 \
    --pod-network-cidr 10.244.0.0/16
```


# Setup the kube config on k8s-cp

```
# exit from root
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

# Let's install Calico

```
wget https://docs.projectcalico.org/manifests/calico.yaml

kubectl apply -f ./calico.yaml

```