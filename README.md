Redis-cluster Proxied via Istio
===
This is a demo of setting up a Redis Cluster in Kubernetes and proxying it using Istio/Envoy.
From the perspective of an application, there is only one Redis instance running at 127.0.0.1:6380.

Getting Started
---
In order to run this demo, you'll need a Docker environment like `Docker Desktop`, `istioctl` and `helm`.

### Install Istio
If Istio is already running in your cluster, skip this step.
```
istioctl install --context=docker-desktop --set profile=demo -y
```

### Deploy Redis Cluster and Istio Proxy
```
# Create namespace with auto-injection
kubectl create namespace redis-cluster --context=docker-desktop
kubectl label namespace redis-cluster istio-injection=enabled --context=docker-desktop

# Create the Redis Cluster and Envoy filters
helm dep build
helm upgrade --install --kube-context=docker-desktop -n=redis-cluster --create-namespace redis-cluster .
```

### Connect to the cluster using Redis-cli
```
kubectl run -i --tty --rm --image redis redis-client --context=docker-desktop -n=redis-cluster -- redis-cli -h 127.0.0.1 -p 6380
```
```
127.0.0.1:6380> mset a hello b world
OK
127.0.0.1:6380> mget a b
1) "hello"
2) "world"
```
