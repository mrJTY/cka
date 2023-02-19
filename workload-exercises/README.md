# Exercises working with workloads

Let's setup a namespace:
```
$ k create ns workloads
```

# Creating a deployment

Create a deployment with:
* an image of `nginx`
* with 3 replicas


Start with this template:

```bash
$ k create deploy -o yaml --dry-run=client --image=nginx:1.17.0 --namespace workloads --replicas 3 nginx > nginx.yaml
```

Look at `nginx.yaml` and apply it


```
$ k apply -f ./nginx.yaml
```

# Scaling a deployment

You can deploy with the `scale` command.

```
k scale --replicas=4 deployments/nginx -n workloads
```

But I prefer modifying the yaml file instead.

```bash
k edit deployment -n workloads nginx
```

# Horizontal pod autoscaler

Create a horizontal pod autoscaler for the deployment you just made so that:
* avg CPU utilization is 70%
* avg memory utilzation is 1Gi
* set minimum replicas to 3
* set maximum replicas to 5


For help:
* https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/

```
k autoscale deploy --help
```

To create the autoscaler:
```
$ k autoscale deploy -n workloads nginx --dry-run=client -o yaml --cpu-percent 70 --min 3 --max 5 --namespace workloads  > hpa.yaml
```

So when we scale the deployment back to just 1 replica, the HPA will scale it back up to 3 as the minimum.


# Creating secrets


Create a secret and assign:
* `email=foo@bar.com`
* `password=super-secret-123`
* Mount it as a `/etc/my-secret` with read only permissions to pods in the deployment


Getting help:
```
$ k create secret generic --help
```

```
k create secret generic --dry-run=client -o yaml --from-literal email=foo@bar.com --from-literal password=super-secret-123 my-secret --namespace workloads > secret.yaml
```