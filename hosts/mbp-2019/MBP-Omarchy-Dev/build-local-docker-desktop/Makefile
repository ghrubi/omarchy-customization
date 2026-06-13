CLUSTER_NAME := docker-desktop
REGISTRY_NAME := docker-desktop-registry
REGISTRY_PORT := 5000
KUBE_CONTEXT_ALIAS := docker-desktop

.PHONY: help create delete restart bootstrap context registry status nodes pods pvc storage clean nuke

help:
	@echo "Docker Desktop replacement using Docker Engine + k3d"
	@echo ""
	@echo "Targets:"
	@echo "  make create      Create k3d cluster + registry"
	@echo "  make bootstrap   Add Docker Desktop compatibility bits"
	@echo "  make restart     Delete and recreate everything"
	@echo "  make delete      Delete k3d cluster only"
	@echo "  make clean       Delete cluster and registry"
	@echo "  make nuke        Force-remove stale k3d Docker resources"
	@echo "  make status      Show cluster, registry, and context"
	@echo "  make nodes       Show Kubernetes nodes"
	@echo "  make pods        Show all pods"
	@echo "  make pvc         Show all PVCs"
	@echo "  make storage     Show storage classes"

registry:
	@k3d registry list | grep -q "$(REGISTRY_NAME)" || \
		k3d registry create $(REGISTRY_NAME) --port 0.0.0.0:$(REGISTRY_PORT)

create: registry
	k3d cluster create $(CLUSTER_NAME) \
		--servers 1 \
		--agents 2 \
		--registry-use k3d-$(REGISTRY_NAME):5000 \
		--registry-config k3d/registries.yaml \
		-p "8080:80@loadbalancer" \
		-p "8443:443@loadbalancer"
	$(MAKE) bootstrap

bootstrap:
	k3d kubeconfig merge $(CLUSTER_NAME) --kubeconfig-switch-context
	kubectl config rename-context k3d-$(CLUSTER_NAME) $(KUBE_CONTEXT_ALIAS) || true
	kubectl config use-context $(KUBE_CONTEXT_ALIAS)
	kubectl apply -f k8s/storageclass-hostpath.yaml
	kubectl get storageclass
	kubectl get nodes

delete:
	k3d cluster delete $(CLUSTER_NAME) || true

restart: delete create

clean:
	k3d cluster delete $(CLUSTER_NAME) || true
	k3d registry delete $(REGISTRY_NAME) || true

status:
	@echo "Current context:"
	@kubectl config current-context || true
	@echo ""
	@echo "k3d clusters:"
	@k3d cluster list || true
	@echo ""
	@echo "k3d registries:"
	@k3d registry list || true
	@echo ""
	@echo "Docker containers:"
	@docker ps --filter "name=k3d-$(CLUSTER_NAME)" --filter "name=k3d-$(REGISTRY_NAME)"

nodes:
	kubectl get nodes -o wide

pods:
	kubectl get pods -A

pvc:
	kubectl get pvc -A

storage:
	kubectl get storageclass

nuke:
	-docker rm -f $$(docker ps -aq --filter "name=k3d-$(CLUSTER_NAME)") 2>/dev/null || true
	-docker rm -f k3d-$(REGISTRY_NAME) 2>/dev/null || true
	-docker network rm k3d-$(CLUSTER_NAME) 2>/dev/null || true
	-docker volume rm k3d-$(CLUSTER_NAME)-images 2>/dev/null || true
	-kubectl config delete-context $(KUBE_CONTEXT_ALIAS) 2>/dev/null || true
