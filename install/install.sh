sudo -i

# Go to root

apt-get update && apt-get upgrade -y

apt-get isntall -y vim

# Install docker

apt-get install -y docker.io

# Add k8s to repository

deb http://apt.kubernetes.io/ kubernetes-xenial main

# Add gpg key

curl -s \
	https://packages.cloud.google.com/apt/doc/apt-key.gpg \
	| apt-key add -

apt-get upgrade


# Install kubeadm

apt-get install -y kubeadm=1.22.1-00 kubelet=1.22.1-00 kubectl=1.22.1-00
apt-mark hold kubelet kubeadm kubectl

# Install calico
wget https://docs.projectcalico.org/manifests/calico.yaml
