# Acceso a servicios - K3s Dev Platform Lab

## Acceso rapido (todos los servicios)

```bash
bash scripts/port-forward-all.sh
```

Esto levanta todos los port-forwards de una vez. Presiona `Ctrl+C` para detenerlos.

---

## Servicios individuales

### ArgoCD
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
- URL: https://localhost:8080
- Usuario: admin
- Password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Grafana
```bash
kubectl port-forward svc/grafana -n monitoring 3000:80
```
- URL: http://localhost:3000
- Usuario: admin / Password: admin
- Datasources preconfigurados: Prometheus + Loki

### Prometheus
```bash
kubectl port-forward svc/prometheus-server -n monitoring 9090:80
```
- URL: http://localhost:9090

### SonarQube
```bash
kubectl port-forward svc/sonarqube -n sonarqube 9001:9000
```
- URL: http://localhost:9001
- Usuario: admin / Password: admin (pide cambiarla al primer login)

### pgAdmin
```bash
kubectl port-forward svc/pgadmin -n postgres 5050:80
```
- URL: http://localhost:5050
- Email: admin@devlab.com / Password: admin123
- Para conectar a PostgreSQL: host `postgres`, puerto `5432`, usuario `admin`, password `admin123`

### PostgreSQL
```bash
kubectl port-forward svc/postgres -n postgres 5432:5432
```
- Host: localhost:5432
- Usuario: admin / Password: admin123
- Base de datos: devlab

### Sample App
```bash
kubectl port-forward svc/sample-app -n sample-app 8081:80
```
- URL: http://localhost:8081

### Loki (API)
```bash
kubectl port-forward svc/loki -n logging 3100:3100
```
- URL: http://localhost:3100/ready

### Ingress NGINX (NodePort)
- HTTP: http://localhost:31080
- HTTPS: https://localhost:31443

> **Nota:** NGINX Ingress usa NodePort porque K3s trae Traefik ocupando los puertos 80/443. Para usar NGINX en puertos estandar, instalar K3s con `--disable traefik`.
