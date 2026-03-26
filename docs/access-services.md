# Acceso a servicios - K3s Dev Platform Lab

Todos los comandos usan `KUBECONFIG=~/.kube/config-k3s`.

## ArgoCD
```bash
KUBECONFIG=~/.kube/config-k3s kubectl port-forward svc/argocd-server -n argocd 8080:443
```
- URL: https://localhost:8080
- Usuario: admin
- Password:
```bash
KUBECONFIG=~/.kube/config-k3s kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Grafana
```bash
KUBECONFIG=~/.kube/config-k3s kubectl port-forward svc/grafana -n monitoring 3000:80
```
- URL: http://localhost:3000
- Usuario: admin / Password: admin
- Datasources preconfigurados: Prometheus + Loki

## Prometheus
```bash
KUBECONFIG=~/.kube/config-k3s kubectl port-forward svc/prometheus-server -n monitoring 9090:80
```
- URL: http://localhost:9090

## Sample App
```bash
KUBECONFIG=~/.kube/config-k3s kubectl port-forward svc/sample-app -n sample-app 8081:80
```
- URL: http://localhost:8081

## Loki (API)
```bash
KUBECONFIG=~/.kube/config-k3s kubectl port-forward svc/loki -n logging 3100:3100
```
- URL: http://localhost:3100/ready

## Ingress NGINX (NodePort)
- HTTP: http://localhost:31080
- HTTPS: https://localhost:31443
