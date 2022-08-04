# create namespaces
lab 15.2 for devdan

```sh
k create ns dev
k create ns prod
```


```sh
k config get-contexts
```


```sh
sudo useradd -s /bin/bash devdan
sudo passwd devdan
```

# Create a KEY and CSR
```sh
openssl genrsa -out devdan.key 2048
openssl req -new \
    -key devdan.key \
    -out devdan.csr \
    -subj "/CN=devdan/O=dev" # CN is user O is group
```

# Create a self-signed cert using x509

* uses k8s cluster keys and 30 expiration

```sh
sudo openssl x509 -req \
    -in devdan.csr \
    -CA /etc/kubernetes/pki/ca.crt \
    -CAkey /etc/kubernetes/pki/ca.key \
    -CAcreateserial \
    -out devdan.crt \
    -days 30
```

# Update the access config file

```sh
k config set-credentials devdan \
  --client-certificate ~/devdan.crt \
  --client-key ~/devdan.key
# User "devdan" set.
```

# Create a context 

```sh
k config set-context devdan-context \
    --cluster kubernetes \
    --namespace dev \
    --user devdan
```

# Try to do stuff as devdan

```sh
k --context devdan-context get pods

# forbidden
```

# Check what has diff'd

```
$ diff ./kubeadm-config.yaml .kube/config
```

# Define a role

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: dev
  name: developer
rules:
- apiGroups: ["", "extensions", "apps"] # "" indicates the core API group
  resources: ["deployments", "replicasets", "pods"]
  verbs: ["get", "watch", "list", "create", "update", "patch", "delete"]
```

# Now bind it

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer-role-binding
  namespace: dev
subjects:
- kind: User
  name: devdan
  apiGroup: ""
roleRef:
  kind: Role
  name: developer
  apiGroup: ""
```

# If we try it again
now we have access to the pods in dev

```sh
k --context devdan-context get pods --namespace dev
# No resources found in dev namespace
```