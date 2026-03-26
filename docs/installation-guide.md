# Guia de instalacion paso a paso

## Requisitos previos

- Linux (Ubuntu 20.04+ recomendado)
- 2 CPU / 4GB RAM minimo
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
./scripts/bootstrap.sh
```

Esto instala K3s, los addons del cluster y ArgoCD.

## Paso 3: Desplegar infraestructura

```bash
./scripts/deploy-infra.sh
```

Esto despliega Prometheus, Grafana, Loki y registra las apps en ArgoCD.

## Paso 4: Acceder a los servicios

### ArgoCD
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Abrir https://localhost:8080
# Usuario: admin
# Password:
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Grafana
```bash
kubectl port-forward svc/grafana -n monitoring 3000:80
# Abrir http://localhost:3000
# Usuario: admin / Password: admin
```

## Paso 5: Verificar

```bash
kubectl get nodes
kubectl get pods -A
kubectl get applications -n argocd
```

## Limpieza

Para eliminar todo el entorno:

```bash
./scripts/cleanup.sh
```
