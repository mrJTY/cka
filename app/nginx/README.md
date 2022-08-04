https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

# Describe the deployment

```sh
k describe deploy nginx
k get deploy nginx -o yaml
```

# Creating deployment two from cli

```sh
k create deploy two \
    --image=nginx \
    --dry-run=client \ # how to cheat with easy yaml definitions
    -o yaml

# easy way to generate yaml
```



# Another example, create a role with yaml

```
k create role foo --verb=get --resource=pod --dry-run=client -o yaml
```

# But deployment rollout not finishing...

```sh
k rollout status deployment/nginx
Waiting for deployment "nginx" rollout to finish: 0 of 1 updated replicas are available...
```

# Troubleshooting
https://www.containiq.com/post/troubleshooting-failed-to-create-pod-sandbox-error