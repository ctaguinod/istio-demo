## istio-demo

This is a quick guide to do a demo based on the Istio official docs:
1. [Istio Offical Docs](https://istio.io/docs/) 
2. [Quick Start with Google Kubernetes Engine](https://istio.io/docs/setup/kubernetes/quick-start-gke-dm.html)
3. [Traffic Management](https://istio.io/docs/tasks/traffic-management/)

### Before you begin.

1. You'll need a [Google Cloud Platform](https://cloud.google.com/) account. 
2. You already have a running [GKE](https://cloud.google.com/kubernetes-engine/) Cluster. If not you may follow this [terraform-gke](https://github.com/ctaguinod/terraform-gke) guide to quickly provision GKE using terraform.

### Usage

**1. Clone this repo.**

```
git clone https://github.com/ctaguinod/demos/
cd istio-demo/
```

**2. Modify the variables configured in the file `Makefile`.**

Default variables: 

```
ISTIO_VERSION=0.6.0
```

**3. Create RBAC Admin for your current user.**

```
make create-rbac-admin 
```

**4. Install Istio Auth and Addons.** 

```
make istio-auth-install
```

This step will download istio version $(ISTIO_VERSION) and deploy istio-auth.yaml and the istio addons

```
istio-$(ISTIO_VERSION)/install/kubernetes/istio-auth.yaml
istio-$(ISTIO_VERSION)/install/kubernetes/addons/
```

You can read more details here [Quick Start with Google Kubernetes Engine](https://istio.io/docs/setup/kubernetes/quick-start-gke-dm.html)

**5. Verify the installation.**

```
make istio-get-all
```

**6. Port forward the istio addons Zipkin, Grafana, Service Graph and Prometheus.** 

```
make istio-port-forward
```

Use Cloud Shells [Web Preview](https://cloud.google.com/shell/docs/using-web-preview) to access the following: 

```
Zipkin URL/Port: http://localhost:9411
Grafana URL/Port: http://localhost:3000
Dotviz URL/Port: http://localhost:8088/dotviz
Prometheus URL/Port: http://localhost:9090/graph
```

**7. Deploy [Bookinfo](https://istio.io/docs/guides/bookinfo.html).** 

`make istio-deploy-bookinfo` - This will install Bookinfo 

`make get-bookinfo-url` - This will show the bookinfo URL. 

*Please take not that it might take a couple of minutes to complete the deployment before the URL can be accessible*

`make istio-get-all` - This will show the status of the deployments.

*Visit the URL to verify the bookinfo has been deployed properly.*

*You should randomly see the different versions of the app since no routing rules have been applied.*


**8. [Configure Request Routing](https://istio.io/docs/tasks/traffic-management/request-routing.html).**

`make istio-bookinfo-route-all-v1` - *This will to route all traffic to bookinfo V1. Refresh the page couple of times to verify all traffic is routed to V1.*

`make istio-bookinfo-route-user-v2` - *This will route user `jason` to bookinfo V2. Login as user `jason` and traffic should be routed to V2.*

You can test other capabilities of Istio by following guides here: https://istio.io/docs/tasks/traffic-management/

**9. Explore Zipkin, Grafana, Service Graph and Prometheus.** - *It should now provide details on whats happening on bookinfo.*

Use Cloud Shells [Web Preview](https://cloud.google.com/shell/docs/using-web-preview) to access the following: 

```
Zipkin URL/Port: http://localhost:9411
Grafana URL/Port: http://localhost:3000
Dotviz URL/Port: http://localhost:8088/dotviz
Prometheus URL/Port: http://localhost:9090/graph
```

**10. Cleaning Up.**

`make istio-delete-routerules` - This will delete the route rules.

`make istio-delete-bookinfo` - This will delete bookinfo.

`make istio-delete` - **This will delete istio.**


