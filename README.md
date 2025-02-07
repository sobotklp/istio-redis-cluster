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
If you don't see a command prompt, try pressing enter.
> Actually, press Shift-R
127.0.0.1:6380> mset a hello b world
OK
127.0.0.1:6380> mget a b
1) "hello"
2) "world"
```


### Connect to a specific cluster node
You can also connect to specific cluster nodes without going through the proxy.
```
kubectl run -i --tty --rm --image redis specific-node-client --context=docker-desktop -n=redis-cluster -- redis-cli -h redis-cluster-0.redis-cluster-headless -p 6379
```
```
If you don't see a command prompt, try pressing enter.
> Actually, press Shift-R

cluster nodes
6ed71849b4137961d71cbcc66e0d9e313bab491e 10.1.0.134:6379@16379 slave 554bf8ab2dc77b99a95d3c7387055f70267a9479 0 1738954986049 10 connected
b500bf10d64740e295b4f4e0d4987e4bee14e622 10.1.0.138:6379@16379 slave 156b0f5140da48e12d17699a5f72cdf6fcab0237 0 1738954985000 14 connected
554bf8ab2dc77b99a95d3c7387055f70267a9479 10.1.0.137:6379@16379 master - 0 1738954984023 10 connected 5461-10922
6056da69c8cf07dc0be5517caaf874c297f8768b 10.1.0.135:6379@16379 slave 156b0f5140da48e12d17699a5f72cdf6fcab0237 0 1738954985034 14 connected
ef58a8ff5d43052d233c5ae6623f099e854a9768 10.1.0.130:6379@16379 slave 554bf8ab2dc77b99a95d3c7387055f70267a9479 0 1738954987091 10 connected
d9a4ec5d38c5ac665686a362b85918e7f2b26a4f 10.1.0.133:6379@16379 slave 7c52096243c63fad6d9d33be03415e3ee5517e89 0 1738954984000 12 connected
103430e454bf55a76124c80c7e71610f6874a710 10.1.0.131:6379@16379 slave 7c52096243c63fad6d9d33be03415e3ee5517e89 0 1738954984000 12 connected
7c52096243c63fad6d9d33be03415e3ee5517e89 10.1.0.136:6379@16379 master - 0 1738954984000 12 connected 10923-16383
156b0f5140da48e12d17699a5f72cdf6fcab0237 10.1.0.132:6379@16379 myself,master - 0 0 14 connected 0-5460
```
