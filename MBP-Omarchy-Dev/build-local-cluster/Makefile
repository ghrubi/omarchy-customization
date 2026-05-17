CLUSTER_NAME := omarchy-dev
REGISTRY_NAME := omarchy-registry
REGISTRY_PORT := 5000

registry:
	k3d registry list | grep -q "$(REGISTRY_NAME)" || \
	k3d registry create $(REGISTRY_NAME) --port 0.0.0.0:$(REGISTRY_PORT)

create: registry
	k3d cluster create $(CLUSTER_NAME) \
		--servers 1 \
		--agents 2 \
		--registry-use k3d-$(REGISTRY_NAME):5000 \
		--registry-config k3d/registries.yaml \
		-p "8080:80@loadbalancer" \
		-p "8443:443@loadbalancer"

delete:
	k3d cluster delete $(CLUSTER_NAME) || true

clean:
	k3d cluster delete $(CLUSTER_NAME) || true
	k3d registry delete $(REGISTRY_NAME) || true

restart: delete create

status:
	k3d cluster list
	k3d registry list
	docker ps --filter "name=k3d-$(CLUSTER_NAME)" --filter "name=k3d-$(REGISTRY_NAME)"

nuke:
	docker rm -f $$(docker ps -aq --filter "name=k3d-$(CLUSTER_NAME)") 2>/dev/null || true
	docker rm -f k3d-$(REGISTRY_NAME) 2>/dev/null || true
	docker network rm k3d-$(CLUSTER_NAME) 2>/dev/null || true
	docker volume rm k3d-$(CLUSTER_NAME)-images 2>/dev/null || true

nodes:
	kubectl get nodes -o wide

pods:
	kubectl get pods -A

test-nginx:
	kubectl create deployment nginx --image=nginx
	kubectl expose deployment nginx --port=80 --type=ClusterIP

test-forward:
	kubectl port-forward svc/nginx 8081:80

test-clean:
	kubectl delete service nginx || true
	kubectl delete deployment nginx || true
