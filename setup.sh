#!/usr/bin/env bash

echo "Install Golang"
sudo snap install go --classic
GO111MODULE="on" go get sigs.k8s.io/kind@v0.5.1
export PATH=$(go env GOPATH)/bin:$PATH

echo "Install Cluster Using Kind"
kind create cluster --config config
export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"
echo "Done"

echo "Get network mask"
export NETWORK_MASK=$(docker network inspect bridge | jq .[0].IPAM.Config[0].Gateway -r)

echo "Install MetalLB"
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml