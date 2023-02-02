This creates a basic deployment and exposes this as a service.

# Step 1: Create a new deployment
```
alias k="minikube kubectl --"
k create deployment --image=k8s.gcr.io/echoserver:1.10 --port 8080 --namespace external --dry-run=client -o yaml echoserver > echoserver.yaml
k apply -f ./echoserver.yaml
```


# Types of services

1. ClusterIP - A service is only accessible in the cluster.
2. NodePort - A service is accessible outside the cluster.
3. A service is exposed using a cloud provider's load balancer.

# Expose the echoserver

```
k expose deployment echoserver -n external --port 80 --target-port 8080 --dry-run=client -o yaml > expose.yaml
k apply -f expose.yaml

k get endpoints echoserver


k describe endpoints echoserver
Name:         echoserver
Namespace:    default
Labels:       app=echoserver
Annotations:  endpoints.kubernetes.io/last-change-trigger-time: 2023-02-02T10:54:34Z
Subsets:
Events:  <none>
```



# Create a cluster ip

```
k create svc clusterip echoserver -n external --tcp=5005:8080 --dry-run=client -o yaml > clusterip.yaml
$ k get svc -n external
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
echoserver   ClusterIP   10.107.158.211   <none>        5005/TCP   27m

```

## Now test if you can wget within the cluster
It is only accessible within the cluster

```
k get po,svc -n external
NAME                              READY   STATUS    RESTARTS   AGE
pod/echoserver-6b869b8bf8-vgxxh   1/1     Running   0          24m

NAME                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/echoserver   ClusterIP   10.107.158.211   <none>        5005/TCP   29m


k run tmp --image=busybox --restart=Never -it --rm -n external -- wget 10.107.158.211:5005 --timeout=1

Connecting to 10.107.158.211:5005 (10.107.158.211:5005)
saving to 'index.html'
index.html           100% |********************************|   431  0:00:00 ETA
'index.html' saved
pod "tmp" deleted

It works! yay!
```


# Create a nodeport

But it is not accessible yet outside of the cluster. Let us now expose it.

```
k create svc nodeport echoserver -n external --tcp=5005:8080 --dry-run=client -o yaml > nodeport.yaml
```

`port` is the service port, while `target-port` is the container/pod port



# Accessing from within

To access from within, we have to create a nodeport service IN THE DEFAULT NAMESPACE

```
k create svc nodeport echoserver --tcp=5005:8080 --dry-run=client -o yaml > nodeport.yaml
k get svc
```




# Create a load balancer
```
k create svc loadbalancer nginx-service --tcp=5050:8080
```

# Now see if you can curl and get a service!

```
curl $(minikube ip):80080
```
