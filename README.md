# K3s Dev Platform Lab

Plataforma de desarrollo basada en **K3s** orientada a practicas de **DevOps, GitOps e infraestructura cloud-native**.

Este repositorio implementa un entorno completo con monitoreo, logging y despliegue automatizado de aplicaciones usando **ArgoCD**.

---

## Objetivos del proyecto

- Construir un laboratorio funcional de Kubernetes ligero con **K3s**
- Implementar practicas de **GitOps**
- Desplegar infraestructura base (observabilidad y CI/CD)
- Servir como entorno de pruebas para aplicaciones cloud-native
- Documentar una arquitectura realista para portafolio DevOps

---

## Arquitectura

```
k3s-platform/
├── .github/workflows/  # CI/CD pipelines (lint, trivy, sonar, build, rollback)
├── cluster/            # Bootstrap del cluster y addons base
├── infrastructure/     # Observabilidad, GitOps y herramientas DevOps
├── apps/               # Aplicaciones desplegadas en Kubernetes
├── argocd-apps/        # Definiciones GitOps (ArgoCD)
├── scripts/            # Automatizacion
├── docs/               # Documentacion
```

---

## Stack tecnologico

- **Kubernetes (K3s)**
- **ArgoCD** (GitOps) + **Image Updater**
- **Prometheus** (monitoring)
- **Grafana** (visualizacion)
- **Loki** (logging)
- **PostgreSQL 16** + **pgAdmin 4** (base de datos)
- **SonarQube** (analisis de codigo)
- **Trivy** (escaneo de vulnerabilidades)
- **GitHub Actions** (CI/CD)
- **NGINX Ingress Controller**
- **Cert-Manager**

---

## Flujo GitOps

1. Se define una aplicacion en `apps/`
2. Se registra en `argocd-apps/`
3. **ArgoCD** detecta cambios en el repositorio
4. Despliega automaticamente al cluster

---

## Instalacion rapida (recomendado)

El script `bootstrap.sh` instala K3s, los addons y ArgoCD de una sola vez:

```bash
git clone https://github.com/zer0-sh/k3s-platform.git
cd k3s-platform
bash scripts/bootstrap.sh
```

Luego despliega la infraestructura de observabilidad:

```bash
bash scripts/deploy-infra.sh
```

---

## Instalacion paso a paso

### 1. Clonar repositorio

```bash
git clone https://github.com/zer0-sh/k3s-platform.git
cd k3s-platform
```

### 2. Instalar K3s

```bash
curl -sfL https://get.k3s.io | sh -
```

Configurar kubeconfig para que `kubectl` funcione sin `sudo`:

```bash
mkdir -p "$HOME/.kube"
sudo cp /etc/rancher/k3s/k3s.yaml "$HOME/.kube/config"
sudo chown "$(id -u):$(id -g)" "$HOME/.kube/config"
export KUBECONFIG="$HOME/.kube/config"
```

Verificar:

```bash
kubectl get nodes
```

### 3. Instalar addons del cluster

```bash
kubectl apply -f cluster/addons/metrics-server/
kubectl apply -f cluster/addons/ingress-nginx/
kubectl apply -f cluster/addons/cert-manager/
```

### 4. Instalar ArgoCD

```bash
kubectl apply -f infrastructure/argocd/namespace.yaml
kubectl apply -f infrastructure/argocd/installation.yaml
```

Obtener contrasena inicial:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

### 5. Acceder a ArgoCD

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Abrir: https://localhost:8080
- Usuario: `admin`
- Password: el obtenido en el paso anterior

### 6. Desplegar infraestructura de observabilidad

```bash
bash scripts/deploy-infra.sh
```

Esto instala Prometheus, Grafana y Loki.

### 7. Registrar aplicaciones en ArgoCD

```bash
kubectl apply -f argocd-apps/
```

---

## Observabilidad

El stack de observabilidad incluye:

| Servicio   | Funcion              | Acceso local                  | Credenciales              |
|------------|---------------------|-------------------------------|---------------------------|
| ArgoCD     | GitOps              | https://localhost:8080         | admin / (auto)            |
| Grafana    | Dashboards          | http://localhost:3000          | admin / admin             |
| Prometheus | Metricas            | http://localhost:9090          | -                         |
| SonarQube  | Analisis de codigo  | http://localhost:9001          | admin / admin             |
| pgAdmin    | Admin PostgreSQL    | http://localhost:5050          | admin@devlab.com / admin123 |
| PostgreSQL | Base de datos       | localhost:5432                 | admin / admin123          |
| Sample App | App de ejemplo      | http://localhost:8081          | -                         |
| Loki       | Logs                | http://localhost:3100/ready    | -                         |

Para levantar todos los port-forwards de una vez:

```bash
bash scripts/port-forward-all.sh
```

Esto expone ArgoCD, Grafana, Prometheus, Loki y la sample-app. Presiona `Ctrl+C` para detener todos.

---

## Scripts disponibles

| Script                        | Descripcion                                      |
|-------------------------------|--------------------------------------------------|
| `scripts/bootstrap.sh`        | Instala K3s, addons y ArgoCD                     |
| `scripts/deploy-infra.sh`     | Despliega monitoring y logging                   |
| `scripts/port-forward-all.sh` | Levanta port-forwards a todos los servicios      |
| `scripts/cleanup.sh`          | Desinstala K3s y limpia el entorno               |

---

## GitHub Secrets requeridos

Para que los workflows de CI/CD funcionen, configura estos secrets en **Settings > Secrets and variables > Actions**:

| Secret | Descripcion | Como obtenerlo |
|--------|-------------|----------------|
| `DOCKERHUB_USERNAME` | Usuario de Docker Hub | `steven58380` |
| `DOCKERHUB_TOKEN` | Access Token de Docker Hub | Docker Hub > Account Settings > Security > New Access Token |
| `SONAR_TOKEN` | Token de autenticacion de SonarQube | SonarQube > My Account > Security > Generate Token |
| `SONAR_HOST_URL` | URL del servidor SonarQube | Ej: `https://sonar.example.com` |
| `ARGOCD_AUTH_TOKEN` | Token de ArgoCD para rollback automatico | `argocd account generate-token --account ci` |
| `ARGOCD_SERVER` | URL publica del servidor ArgoCD | Ej: `argocd.example.com:443` |

---

## Limpieza

Para desinstalar K3s y eliminar todos los recursos:

```bash
bash scripts/cleanup.sh
```

---

## Estructura detallada

### cluster/
Configuracion base del cluster:
- Instalacion de K3s (`cluster/bootstrap/`)
- Metrics Server (`cluster/addons/metrics-server/`)
- Ingress Controller (`cluster/addons/ingress-nginx/`)
- Cert-Manager (`cluster/addons/cert-manager/`)

### infrastructure/
Servicios de plataforma:
- Monitoring: Prometheus + Grafana (`infrastructure/monitoring/`)
- Logging: Loki (`infrastructure/logging/`)
- GitOps: ArgoCD + Image Updater (`infrastructure/argocd/`, `infrastructure/argocd-image-updater/`)
- Code Quality: SonarQube + PostgreSQL (`infrastructure/sonarqube/`)

### apps/
Aplicaciones:
- `sample-app/` - App de ejemplo con Dockerfile, Deployment, Service, ConfigMap, Ingress, Namespace
- `postgres/` - PostgreSQL 16 (StatefulSet + PVC) + pgAdmin 4

### argocd-apps/
Definiciones de aplicaciones gestionadas por ArgoCD:
- `sample-app.yaml` (con annotations de Image Updater)
- `postgres.yaml`
- `infrastructure.yaml`
- `sonarqube.yaml`

### scripts/
Automatizacion del entorno (bootstrap, deploy, port-forward, cleanup).

### docs/
Documentacion del proyecto (arquitectura, portfolio, guias, acceso a servicios).

---

## Casos de uso

- Laboratorio de Kubernetes
- Practica de CI/CD y GitOps
- Simulacion de entornos productivos
- Practica de observabilidad
- Testing de microservicios
