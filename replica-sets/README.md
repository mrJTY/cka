
Create the replica set

```sh
k create -f ./replica-sets/rs.yaml
```

# Delete without deleting the pods

To delete replica sets but not the pods it controls...
```sh
k delete rs rs-one --cascade=orphan
```

# Describe the replica sets

```
k describe rs rs-one
```