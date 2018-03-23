# istio-demo

This guide is just meant to do a quick demo based on the following official Istio docs, detailed tutorials can be found at:

1. [Istio Offical Docs](https://istio.io/docs/) 
2. [Quick Start with Google Kubernetes Engine](https://istio.io/docs/setup/kubernetes/quick-start-gke-dm.html)
3. [Traffic Management](https://istio.io/docs/tasks/traffic-management/)

## Before you begin.

This guide assumes that:

1. You are already familiar with and have a [Google Cloud Platform](https://cloud.google.com/) account.
2. You are already familiar with [Kubernetes](https://kubernetes.io/). If you are looking for a basic tutorial, here's a good [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/) tutorial. 
3. You are already familiar with [Terraform](https://www.terraform.io/). If you are looking for a detailed tutorial, here's a good [Introduction to Terraform](https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180) tutorial.
4. [Google Cloud Shell](https://cloud.google.com/shell/) will be used.
5. You already have a running [GKE](https://cloud.google.com/kubernetes-engine/) Cluster. If not you may follow this [terraform-gke](https://github.com/ctaguinod/terraform-gke) guide to quickly provision GKE.
 
## Let's start

1. Start Cloud Shell. 

2. Clone this repo.
```
git clone https://github.com/ctaguinod/demos/
cd istio-demo/
```

3. Modify the variables configured in the file `Makefile`.

Default variables are as follows: 

```
ISTIO_VERSION=0.6.0
```

4. Create RBAC Admin for your current user: Run: `make create-rbac-admin` 

5. Install Istio Auth: Run: `make istio-auth-install`

You can read more details here [Quick Start with Google Kubernetes Engine](https://istio.io/docs/setup/kubernetes/quick-start-gke-dm.html)

Run: `make get-all` to verify the installation.

6. Setup forwarding for Zipkin, Grafana, Service Graph and Prometheus. Run: `make istio-port-forward`

Use Cloud Shells Web Preview feature to access the following:
```
Zipkin URL/Port: http://localhost:9411
Grafana URL/Port: http://localhost:3000
Dotviz URL/Port: http://localhost:8088/dotviz
Prometheus URL/Port: http://localhost:9090/graph
```

7. Deploy [Bookinfo](https://istio.io/docs/guides/bookinfo.html). Run: `make istio-deploy-bookinfo` You can get the bookinfo url by running `make get-bookinfo-url`. 

Visit the URL to verify the bookinfo has been deployed properly. You should randomly see the different versions of the app since no routing rules have been applied.

To verify the status of the deployment you can run: `make get-all`


8. [Configure Request Routing](https://istio.io/docs/tasks/traffic-management/request-routing.html). 

Run: `make istio-bookinfo-route-all-v1` to route all traffic to bookinfo V2. Refresh the page couple of times to verify all traffic is routed to V2.

Run: `make istio-bookinfo-route-user-v2` to route user `jason` to bookinfo V2. Login as user `jason` and traffic should be routed to V2.

You can test other capabilities of Istio by following guides here: https://istio.io/docs/tasks/traffic-management/

9. Cleanup.

Run: `make istio-delete-routerules` to delete the route rules.

Run: `make istio-delete-bookinfo` to delete bookinfo.


