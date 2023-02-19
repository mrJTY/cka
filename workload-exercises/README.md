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

Now create a deployment with the secret

```
k create deploy --image nginx nginx-with-secret --namespace workloads --replicas=1 --dry-run=client -o yaml > nginx-with-secret.yaml
```

Then we need to add it as a volume mount:

```yaml
spec:
  containers:
  - name: container
    ...
    volumeMounts:
    - name: foo
      mountPath: "/etc/foo"
      readOnly: true
 
  # volumes is the same level as containers
  volumes:
  - name: foo
    secret:
      secretName: my-secret
```

For help:
* https://kubernetes.io/docs/concepts/configuration/secret/#restriction-secret-must-exist

Now let's find a running pod to check if the secret is accessible:

```
$ k get po -n workloads | grep with-secret
nginx-with-secret-7d4c58d5b5-m64bh   1/1     Running   0          2m15s
```

```bash
$ k exec -ti nginx-with-secret-7d4c58d5b5-m64bh -n workloads -- ls /etc/my-secret
email  password

$ k exec -ti nginx-with-secret-7d4c58d5b5-m64bh -n workloads -- cat /etc/my-secret/email
foo@bar.com

$ k exec -ti nginx-with-secret-7d4c58d5b5-m64bh -n workloads -- cat /etc/my-secret/password
super-secret-123
```

# Clean up

Let's clean up the namespace and tear down the resources for this exercise.