SHELL=/bin/bash
# HOME_DIR=$(shell echo ${HOME})

# .PHONY: all lint pretty clean build push deploy

all: deploy deployment-info

deploy:
	export KUBECONFIG='${HOME}/.kube/minikube'
	minikube start --embed-certs
	kubectl apply --filename deployment-app.yaml --namespace default
	kubectl rollout status deployment web

deployment-info:
	kubectl describe deployment web

port-forward:
	kubectl port-forward --address 0.0.0.0 deployment/web 8080:9057

clean: 
	kubectl delete deployment web
	minikube stop