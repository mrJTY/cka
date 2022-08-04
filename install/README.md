Source: https://medium.com/swlh/setup-own-kubernetes-cluster-via-virtualbox-99a82605bfcc


```
nix-shell .

vagrant up
```

# init the control plane

Save this as kubeadm-config.yaml

```yaml
apiVersion: kubeadm.k8s.io/v1beta2 
kind: ClusterConfiguration 
kubernetesVersion: 1.22.1 
controlPlaneEndpoint: "k8s-cp:6443" 
networking: 
  podSubnet: 10.244.0.0/16 # can also be: 192.168.0.0/16
apiEndpoint:
  advertiseAddress: 192.168.33.13 # hardcoded in the Vagrantfile
```

```sh
vagrant ssh k8s-cp

kubeadm init --config=./kubeadm-config.yaml
```


# Setup the kube config on k8s-cp

```sh
# exit from root
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

# Check if it is runnig

```sh
systemctl status kubelet

>> active
>> but container runtime network is not ready

# Also check if we have containerd running
systemctl status containerd
```

# Let's install Calico

Installing calico will enable a CNI

```
wget https://docs.projectcalico.org/manifests/calico.yaml

kubectl apply -f ./calico.yaml

```

# Now check

```
k get nodes

vagrant@k8s-cp:~$ k get nodes
NAME     STATUS   ROLES                  AGE    VERSION
k8s-cp   Ready    control-plane,master   4m8s   v1.22.1
```