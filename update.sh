#!/bin/bash

# Create namespace with auto-injection
kubectl create namespace redis-cluster --context=docker-desktop
kubectl label namespace redis-cluster istio-injection=enabled --context=docker-desktop

# Create the Redis Cluster and Envoy filters
helm upgrade --install --kube-context=docker-desktop -n=redis-cluster --create-namespace redis-cluster .


# kubectl exec -it redis-cluster-0 --context=docker-desktop -n=redis-cluster -- redis-cli cluster info
