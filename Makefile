# ISTIO
# LATEST RELEASE: https://github.com/istio/istio/releases
ISTIO_VERSION=0.6.0
ZIPKIN_POD_NAME=$(shell kubectl -n istio-system get pod -l app=zipkin -o jsonpath='{.items[0].metadata.name}')
SERVICEGRAPH_POD_NAME=$(shell kubectl -n istio-system get pod -l app=servicegraph -o jsonpath='{.items[0].metadata.name}')
GRAFANA_POD_NAME=$(shell kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}')
PROMETHEUS_POD_NAME=$(shell kubectl -n istio-system get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}')

export PATH := $(PWD)/istio-$(ISTIO_VERSION)/bin:$(PATH)

.PHONY: help
help:
	@echo Istio Version: $(ISTIO_VERSION)

.PHONY: create-rbac-admin
create-rbac-admin:
	@kubectl create clusterrolebinding user-admin-binding --clusterrole=cluster-admin --user=$(shell gcloud config get-value core/account)
	@kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(shell gcloud config get-value core/account)

.PHONY: istio-auth-install 
istio-install:
	@curl -L https://git.io/getLatestIstio | ISTIO_VERSION=$(ISTIO_VERSION) sh -
	@kubectl apply -f istio-$(ISTIO_VERSION)/install/kubernetes/istio-auth.yaml
	@kubectl apply -f istio-$(ISTIO_VERSION)/install/kubernetes/addons/

.PHONY: istio-delete-all 
istio-delete:
	@kubectl delete -f istio-$(ISTIO_VERSION)/install/kubernetes/addons/
	@kubectl delete -f istio-$(ISTIO_VERSION)/install/kubernetes/istio-auth.yaml
	@rm -rf istio-$(ISTIO_VERSION)/

.PHONY: get-all 
istio-get-all:
	@kubectl get -n istio-system deployments 
	@kubectl get -n istio-system pods
	@kubectl get -n istio-system service
	@kubectl get -n istio-system ingress
	@istioctl get routerule
	@kubectl get deployments
	@kubectl get pods
	@kubectl get service
	@kubectl get ingress

.PHONY: istio-port-forward
istio-port-forward:
	@kubectl -n istio-system port-forward $(ZIPKIN_POD_NAME) 9411:9411 & 
	@echo "Zipkin URL/Port: http://localhost:9411"
	@kubectl -n istio-system port-forward $(GRAFANA_POD_NAME) 3000:3000 &
	@echo "Grafana URL/Port: http://localhost:3000"
	@kubectl -n istio-system port-forward $(SERVICEGRAPH_POD_NAME) 8088:8088 & 
	@echo "Dotviz URL/Port: http://localhost:8088/dotviz"
	@kubectl -n istio-system port-forward $(PROMETHEUS_POD_NAME) 9090:9090 &
	@echo "Prometheus URL/Port: http://localhost:9090/graph"

.PHONY: istio-deploy-bookinfo 
istio-deploy-bookinfo:
	@istioctl kube-inject -f istio-$(ISTIO_VERSION)/samples/bookinfo/kube/bookinfo.yaml | kubectl apply -f - 
	@echo "Bookinfo URL: http://`kubectl get ingress gateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`/productpage"

.PHONY: get-bookinfo-url
bookinfo-url:
	@echo "Bookinfo URL: http://`kubectl get ingress gateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`/productpage"

.PHONY: istio-delete-bookinfo
istio-delete-bookinfo:
	@kubectl delete -f istio-$(ISTIO_VERSION)/samples/bookinfo/kube/bookinfo.yaml

.PHONY: istio-bookinfo-route-all-v1
istio-bookinfo-route-all-v1:
	@echo "Route all traffic to v1"
	@istioctl create -f istio-$(ISTIO_VERSION)/samples/bookinfo/kube/route-rule-all-v1.yaml

.PHONY: istio-bookinfo-route-user-v2
istio-bookinfo-route-user-v2:
	@echo "Route user jason traffic to v2"
	@istioctl create -f istio-$(ISTIO_VERSION)/samples/bookinfo/kube/route-rule-reviews-test-v2.yaml

.PHONY: istio-get-routerule 
istio-get-routerule:
	@istioctl get routerule

.PHONY: istio-delete-routerules
istio-delete-routerules:
	@istioctl delete -f istio-$(ISTIO_VERSION)/samples/bookinfo/kube/route-rule-all-v1.yaml -n default
	@istioctl delete -f istio-$(ISTIO_VERSION)/samples/bookinfo/kube/route-rule-reviews-test-v2.yaml -n default

.PHONY: get-access-token 
get-access-token:
	@kubectl config view | grep -A10 "name: $(shell kubectl config current-context)" | grep access-token

.PHONY: restart-all-pods 
restart-all-pods:
	@kubectl delete pods --all

