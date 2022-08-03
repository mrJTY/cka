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