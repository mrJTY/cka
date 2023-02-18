# Creating a simple persistent volume

Create a simple persistent volume with the following requirements:
* A persistent volume for logs, named `my-pv` in the namespace `logs`
* Mounted at `/tmp/logs`
* Access mode is `ReadWriteOnce`
* Storage capacity of 1Gi
* Assign a reclaim policy of `Delete` 

https://kubernetes.io/docs/concepts/storage/persistent-volumes/

```bash
$ k apply -f ./persistent-volume.yaml 

$ k get pv -n storage

NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
my-pv   1Gi        RWO            Retain           Available                                   111s
```

# Creating a persistent volume claim

Create a persistent volume claim with:
* call it `my-pvc` in the namespace `storage`
* a capacity fo 2Gi
* Access is `ReadWriteOnce`


https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims

```bash
$ k get pvc -n storage
NAME     STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
my-pvc   Bound    pvc-4263871d-ff02-4cbd-9e2d-f56947614390   2Gi        RWO            standard       5s
```

# Mount the pvc to a pod

Mount the pvc you've just created to an `nginx` pod with a mount path `/var/log/nginx`.

First, create the nginx pod:

```
$ k run --help

$ k run nginx --image=nginx -n storage -o yaml --dry-run=client

# Use this as a base for nginx.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
  namespace: storage
spec:
  containers:
  - image: nginx
    name: nginx
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

```

See https://kubernetes.io/docs/concepts/storage/persistent-volumes/#claims-as-volumes

https://kubernetes.io/docs/concepts/storage/ephemeral-volumes/#csi-ephemeral-volumes


```bash
$ k apply -f nginx.yaml 
pod/nginx created

$ k get po -n storage
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          4s

```

Check that you can actually see the storage having files:

```bash
$ k exec -ti nginx -n storage -- sh
# ls /var	
backups  cache	lib  local  lock  log  mail  opt  run  spool  tmp
# ls /var/log/nginx/
access.log  error.log

```