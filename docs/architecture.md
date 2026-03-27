# Arquitectura - K3s Dev Platform Lab

## Diagrama general

```mermaid
flowchart TB
    Dev["Developer"]:::external
    GH["GitHub Repository"]:::external

    Dev -->|git push| GH

    subgraph K3s["K3s Cluster"]
        direction TB

        subgraph GitOps["GitOps"]
            ArgoCD["ArgoCD\n(sync & deploy)"]
            IU["Image Updater\n(detect new tags)"]
            IU -->|update| ArgoCD
        end

        GH -->|webhook / poll| ArgoCD

        subgraph Apps["Applications"]
            SampleApp["sample-app\nDeployment + Service\n+ Ingress + ConfigMap"]
            PG["PostgreSQL 16\n(StatefulSet + PVC)"]
            PGAdmin["pgAdmin 4\n(DB admin UI)"]
        end

        subgraph Observability["Observability Stack"]
            Prometheus["Prometheus\n(metrics)"]
            Grafana["Grafana\n(dashboards)"]
            Loki["Loki\n(log aggregation)"]
            Promtail["Promtail\n(log collection)"]
        end

        subgraph QA["Code Quality"]
            SonarQube["SonarQube\n(static analysis)"]
            SonarDB["PostgreSQL 15\n(SonarQube DB)"]
            SonarQube --> SonarDB
        end

        subgraph Addons["Cluster Addons"]
            Ingress["NGINX Ingress\nController"]
            CertMgr["Cert-Manager"]
        end

        ArgoCD -->|deploy| Apps
        ArgoCD -->|deploy| Observability
        ArgoCD -->|deploy| QA

        Promtail -->|logs| Loki
        Prometheus -->|scrape| SampleApp
        Prometheus -->|scrape| PG
        Prometheus -->|scrape| Addons
        Grafana -->|query| Prometheus
        Grafana -->|query| Loki

        PGAdmin -->|manage| PG

        Ingress -->|route traffic| SampleApp
        Ingress -->|route traffic| ArgoCD
        Ingress -->|route traffic| Grafana
        Ingress -->|route traffic| SonarQube
    end

    DH["Docker Hub"]:::external
    CI["GitHub Actions\n(CI/CD)"]:::external

    GH -->|trigger| CI
    CI -->|push image| DH
    DH -->|poll new tags| IU

    User["User / Browser"]:::external
    User -->|HTTPS| Ingress

    classDef external fill:#f0f0f0,stroke:#999,color:#333
```

## Flujo GitOps

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant GH as GitHub
    participant CI as GitHub Actions
    participant DH as Docker Hub
    participant IU as Image Updater
    participant Argo as ArgoCD
    participant K3s as K3s Cluster

    Dev->>GH: git push (apps/ o infrastructure/)
    GH->>CI: Trigger workflows (lint, trivy, sonar, build)
    CI->>DH: Push Docker image
    DH-->>IU: New tag detected (poll)
    IU->>Argo: Update image in app spec
    Argo->>Argo: Compara estado deseado vs actual
    Argo->>K3s: Aplica manifiestos
    K3s-->>Argo: Reporta estado
    Argo-->>Dev: Sync OK (UI / CLI)
    Note over CI,K3s: Si health check falla -> rollback automatico
```

## Flujo de observabilidad

```mermaid
flowchart LR
    Pods["Pods / Services"] -->|metrics endpoint| Prometheus
    Pods -->|stdout/stderr| Promtail
    Promtail -->|push| Loki
    Prometheus --> Grafana
    Loki --> Grafana
    Grafana -->|dashboards & alerts| User["Operator"]
```

## Flujo CI/CD

```mermaid
flowchart LR
    Push["git push"] --> Lint["KubeLinter\n+ yamllint"]
    Push --> Trivy["Trivy\n(vulnerabilities)"]
    Push --> Sonar["SonarQube\n(code quality)"]
    Push --> Build["Docker Build\n& Push"]
    Build --> IU["Image Updater\ndetects new tag"]
    IU --> Argo["ArgoCD\ndeploys"]
    Argo --> HC["Health Check"]
    HC -->|healthy| Done["Done"]
    HC -->|unhealthy| Rollback["Auto Rollback"]
```

## Componentes

### Capa de cluster (cluster/)
- **K3s**: Distribucion ligera de Kubernetes (v1.34+, incluye Metrics Server)
- **NGINX Ingress**: Controlador de trafico entrante (NodePort 31080/31443)
- **Cert-Manager**: Gestion automatica de certificados TLS

> **Nota:** K3s trae Traefik por defecto ocupando puertos 80/443. NGINX Ingress usa NodePort para evitar el conflicto. Para usar puertos estandar, instalar K3s con `--disable traefik`.

### Capa de infraestructura (infrastructure/)
- **ArgoCD**: Motor de GitOps para despliegue continuo
- **ArgoCD Image Updater**: Detecta nuevas imagenes en Docker Hub y actualiza deployments
- **Prometheus**: Recoleccion y almacenamiento de metricas
- **Grafana**: Visualizacion de metricas y logs (dashboard pre-configurado: cluster-overview)
- **Loki + Promtail**: Agregacion y recoleccion de logs
- **SonarQube**: Analisis estatico de codigo (con su propia base de datos PostgreSQL)

### Capa de aplicaciones (apps/)
- **sample-app**: App de ejemplo con Dockerfile, Deployment, Service, ConfigMap, Ingress, Namespace
- **postgres**: PostgreSQL 16 (StatefulSet + PVC) + pgAdmin 4 (UI de administracion)

### Namespaces

| Namespace | Componentes |
|-----------|------------|
| `argocd` | ArgoCD Server, Image Updater |
| `monitoring` | Prometheus, Grafana |
| `logging` | Loki, Promtail |
| `sonarqube` | SonarQube, PostgreSQL (SonarQube DB) |
| `postgres` | PostgreSQL 16, pgAdmin 4 |
| `sample-app` | Sample App |
| `ingress-nginx` | NGINX Ingress Controller |
| `cert-manager` | Cert-Manager |

## Puertos locales (port-forward)

| Servicio   | Puerto local | Credenciales |
|------------|-------------|-------------|
| ArgoCD     | :8080 (HTTPS) | admin / (auto) |
| Grafana    | :3000 | admin / admin |
| Prometheus | :9090 | - |
| SonarQube  | :9001 | admin / admin |
| pgAdmin    | :5050 | admin@devlab.com / admin123 |
| Sample App | :8081 | - |
| PostgreSQL | :5432 | admin / admin123 |
| Loki       | :3100 | - |
