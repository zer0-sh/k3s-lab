# Arquitectura - K3s Dev Platform Lab

## Diagrama general

```
                    +------------------+
                    |    Developer     |
                    +--------+---------+
                             |
                        git push
                             |
                    +--------v---------+
                    |     GitHub       |
                    +--------+---------+
                             |
                    +--------v---------+
                    |     ArgoCD       |
                    |   (GitOps sync)  |
                    +--------+---------+
                             |
              +--------------+--------------+
              |              |              |
     +--------v---+  +------v------+  +----v-------+
     |   Apps      |  | Monitoring  |  |  Logging   |
     | (sample-app)|  | Prometheus  |  |   Loki     |
     |             |  | Grafana     |  |  Promtail  |
     +-------------+  +-------------+  +------------+
              |              |              |
     +--------v--------------v--------------v--------+
     |              K3s Cluster                       |
     |  +----------+  +-----------+  +------------+  |
     |  | Ingress  |  | Cert-Mgr  |  | Metrics    |  |
     |  | NGINX    |  |           |  | Server     |  |
     |  +----------+  +-----------+  +------------+  |
     +------------------------------------------------+
```

## Componentes

### Capa de cluster (cluster/)
- **K3s**: Distribucion ligera de Kubernetes
- **NGINX Ingress**: Controlador de trafico entrante
- **Cert-Manager**: Gestion automatica de certificados TLS
- **Metrics Server**: Metricas de recursos para HPA y kubectl top

### Capa de infraestructura (infrastructure/)
- **ArgoCD**: Motor de GitOps para despliegue continuo
- **Prometheus**: Recoleccion y almacenamiento de metricas
- **Grafana**: Visualizacion de metricas y logs
- **Loki + Promtail**: Agregacion y recoleccion de logs

### Capa de aplicaciones (apps/)
- Aplicaciones desplegadas y gestionadas por ArgoCD
- Cada app incluye: Deployment, Service, ConfigMap, Ingress

## Flujo de datos

1. Prometheus scrapes metricas de pods y servicios
2. Promtail recolecta logs de todos los pods
3. Grafana consulta Prometheus y Loki para dashboards
4. ArgoCD sincroniza el estado del cluster con el repositorio Git
