# Plan de implementacion - K3s Dev Platform Lab

## Fase 1: Estructura base del repositorio
- [x] Crear estructura de directorios
- [x] Crear README.md

## Fase 2: Cluster (cluster/)
- [x]Configuracion de instalacion de K3s (`cluster/bootstrap/`)
- [x]NGINX Ingress Controller (`cluster/addons/ingress-nginx/`)
- [x]Cert-Manager para TLS (`cluster/addons/cert-manager/`)
- [x]Metrics Server (`cluster/addons/metrics-server/`)

## Fase 3: Infrastructure (infrastructure/)
- [x]Instalacion de ArgoCD (`infrastructure/argocd/`)
- [x]Prometheus (`infrastructure/monitoring/prometheus/`)
- [x]Grafana (`infrastructure/monitoring/grafana/`)
- [x]Loki (`infrastructure/logging/loki/`)

## Fase 4: Aplicaciones de ejemplo (apps/)
- [x]App de ejemplo con Deployment, Service, ConfigMap (`apps/sample-app/`)

## Fase 5: GitOps con ArgoCD (argocd-apps/)
- [x]Application para infrastructure (`argocd-apps/infrastructure.yaml`)
- [x]Application para apps (`argocd-apps/sample-app.yaml`)

## Fase 6: Scripts de automatizacion (scripts/)
- [x]Bootstrap del cluster (`scripts/bootstrap.sh`)
- [x]Deploy de infraestructura (`scripts/deploy-infra.sh`)
- [x]Limpieza del entorno (`scripts/cleanup.sh`)

## Fase 7: Documentacion (docs/)
- [x]Guia de arquitectura (`docs/architecture.md`)
- [x]Guia de instalacion paso a paso (`docs/installation-guide.md`)

---

## Notas de despliegue (2026-03-26)

### Fix 1: Metrics Server duplicado
- **Problema:** El HelmChart de metrics-server fallo con CrashLoopBackOff. K3s v1.34.5 ya incluye metrics-server por defecto, y el ServiceAccount `metrics-server` en `kube-system` ya existia sin las labels de Helm, causando conflicto de ownership.
- **Solucion:** Se elimino el HelmChart custom (`kubectl delete helmchart metrics-server -n kube-system`). El metrics-server nativo de K3s es suficiente.
- **Accion futura:** No incluir `cluster/addons/metrics-server/` en el bootstrap cuando se use K3s, ya que viene integrado.

### Fix 2: Ingress NGINX vs Traefik (conflicto de puertos)
- **Problema:** ingress-nginx-controller quedo en Pending porque estaba configurado como DaemonSet con `hostPort: true` (puertos 80/443), pero K3s ya trae Traefik ocupando esos puertos.
- **Solucion:** Se cambio ingress-nginx a `Deployment` con `hostPort: false` y `service.type: NodePort` (puertos 31080/31443).
- **Alternativa:** Desactivar Traefik al instalar K3s con `--disable traefik` si se quiere usar exclusivamente NGINX Ingress en puertos 80/443.

### Fix 3: Namespace race condition
- **Problema:** Al aplicar todos los manifiestos de `apps/sample-app/` de una vez, el namespace se creo pero los recursos (configmap, deployment, ingress) fallaron con "namespace not found" porque el namespace aun no estaba disponible.
- **Solucion:** Se re-aplico `kubectl apply -f apps/sample-app/` una segunda vez.
- **Accion futura:** En `scripts/bootstrap.sh`, aplicar el namespace primero y luego el resto, o usar `kubectl apply` dos veces.

### Estado final del cluster
- K3s v1.34.5+k3s1 (nodo: think)
- Todos los pods en Running (25 pods activos)
- Kubeconfig local: `~/.kube/config-k3s`
