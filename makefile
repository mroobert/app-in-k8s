SHELL := /bin/bash


# Running k8s cluster with Kind
KIND_CLUSTER := local-k8s-cluster

kind-up:
	kind create cluster \
		--image kindest/node:v1.21.1@sha256:69860bda5563ac81e3c0057d654b5253219618a22ec3a346306239bba8cfa1a6 \
		--name $(KIND_CLUSTER) \
		--config kind/kind-config.yaml
	kubectl config set-context --current --namespace=app-system
	
ingress-up:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
	kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

kind-down:
	kind delete cluster --name $(KIND_CLUSTER)
