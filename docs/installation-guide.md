# Guia de instalacion paso a paso

## Requisitos previos

- Linux (Ubuntu 20.04+ recomendado)
- 2 CPU / 4GB RAM minimo (8GB recomendado si se incluye SonarQube)
- Acceso root o sudo
- curl instalado

## Paso 1: Clonar el repositorio

```bash
git clone https://github.com/zer0-sh/k3s-platform.git
cd k3s-platform
```

## Paso 2: Ejecutar bootstrap

```bash
chmod +x scripts/*.sh
bash scripts/bootstrap.sh
```

Esto instala K3s, configura kubeconfig, instala los addons del cluster (Ingress NGINX, Cert-Manager) y ArgoCD.

> **Nota:** K3s v1.34+ ya incluye Metrics Server, no es necesario instalarlo por separado.

## Paso 3: Desplegar infraestructura

```bash
bash scripts/deploy-infra.sh
```

Esto despliega Prometheus, Grafana, Loki y registra las apps en ArgoCD.

## Paso 4: Desplegar componentes adicionales

### PostgreSQL + pgAdmin
```bash
kubectl apply -f apps/postgres/
kubectl apply -f argocd-apps/postgres.yaml
```

### SonarQube
```bash
kubectl apply -f infrastructure/sonarqube/
kubectl apply -f argocd-apps/sonarqube.yaml
```

### ArgoCD Image Updater
```bash
kubectl apply -f infrastructure/argocd-image-updater/install.yaml
kubectl apply -f argocd-apps/sample-app.yaml
```

## Paso 5: Acceder a los servicios

La forma mas rapida es usar el script de port-forward:

```bash
bash scripts/port-forward-all.sh
```

Esto expone todos los servicios:

| Servicio | URL | Credenciales |
|----------|-----|-------------|
| ArgoCD | https://localhost:8080 | admin / (auto) |
| Grafana | http://localhost:3000 | admin / admin |
| Prometheus | http://localhost:9090 | - |
| SonarQube | http://localhost:9001 | admin / admin |
| pgAdmin | http://localhost:5050 | admin@devlab.com / admin123 |
| Sample App | http://localhost:8081 | - |

Para mas detalles ver [access-services.md](access-services.md).

## Paso 6: Verificar

```bash
kubectl get nodes
kubectl get pods -A
kubectl get applications -n argocd
```

Deberian aparecer 4 aplicaciones en ArgoCD: `sample-app`, `infrastructure`, `postgres`, `sonarqube`.

## Limpieza

Para eliminar todo el entorno:

```bash
bash scripts/cleanup.sh
```
