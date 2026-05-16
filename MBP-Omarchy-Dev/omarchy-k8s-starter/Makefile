APP ?= hello-go
NS ?= apps

.PHONY: dev run delete status pods logs forward clean

dev:
	cd apps/$(APP) && skaffold dev

run:
	cd apps/$(APP) && skaffold run

delete:
	cd apps/$(APP) && skaffold delete

status:
	kubectl get all -n $(NS)

pods:
	kubectl get pods -n $(NS) -o wide

logs:
	kubectl logs -n $(NS) -l app.kubernetes.io/name=$(APP) -f

# make forward APP=hello-go
forward:
	kubectl port-forward -n $(NS) svc/$(APP) 8081:80

clean:
	kubectl delete namespace $(NS) || true
