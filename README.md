# 🧱 K3s Dev Platform Lab

Plataforma de desarrollo basada en **K3s** orientada a prácticas de **DevOps, GitOps e infraestructura cloud-native**.

Este repositorio implementa un entorno completo con monitoreo, logging y despliegue automatizado de aplicaciones usando **ArgoCD**.

---

## 🚀 Objetivos del proyecto

- Construir un laboratorio funcional de Kubernetes ligero con **K3s**
- Implementar prácticas de **GitOps**
- Desplegar infraestructura base (observabilidad y CI/CD)
- Servir como entorno de pruebas para aplicaciones cloud-native
- Documentar una arquitectura realista para portafolio DevOps

---

## 🏗️ Arquitectura
k3s-platform/
│
├── cluster/ # Bootstrap del cluster y addons base
├── infrastructure/ # Observabilidad y herramientas DevOps
├── apps/ # Aplicaciones desplegadas en Kubernetes
├── argocd-apps/ # Definiciones GitOps (ArgoCD)
├── scripts/ # Automatización
├── docs/ # Documentación

---

## ⚙️ Stack tecnológico

- **Kubernetes (K3s)**
- **ArgoCD** (GitOps)
- **Prometheus** (monitoring)
- **Grafana** (visualización)
- **Loki** (logging)
- **NGINX Ingress Controller**
- **Cert-Manager**

---

## 🔄 Flujo GitOps

1. Se define una aplicación en `apps/`
2. Se registra en `argocd-apps/`
3. **ArgoCD** detecta cambios en el repositorio
4. Despliega automáticamente al cluster

---

## 📦 Instalación

### 1. Clonar repositorio

```bash
git clone https://github.com/zer0-sh/k3s-platform.git
cd k3s-platform
```
### 2. Instalar K3s

```bash
curl -sfL https://get.k3s.io | sh -
```
Verificar:

```bash
kubectl get nodes
```
### 3. Instalar addons del cluster

```bash
kubectl apply -f cluster/addons/
```

### 4. Instalar ArgoCD

```bashkubectl create namespace argocd
kubectl apply -n argocd -f infrastructure/argocd/installation.yaml

```
Obtener contraseña inicial:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

### 5. Acceder a ArgoCD

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Abrir:

```bash
https://localhost:8080
```
Usuario: admin

## 📊 Observabilidad

Incluye:

Prometheus → métricas
Grafana → dashboards
Loki → logs

# 📁 Estructura detallada

## 🟢 cluster/
Configuración base del cluster:
- Instalación de K3s
- Ingress Controller
- Certificados TLS
- Métricas básicas

## 🔵 infrastructure/
Servicios de plataforma:
- Monitoring (Prometheus + Grafana)
- Logging (Loki)
- GitOps (ArgoCD)

## 🟡 apps/

Aplicaciones de ejemplo:
- Deployments
- Services
- ConfigMaps

## 🟣 argocd-apps/
Definiciones de aplicaciones gestionadas por ArgoCD.

Ejemplo:
```bash
apiVersion: argoproj.io/v1alpha1
kind: Application
```

## 🟠 scripts/
Automatización del entorno:
- Bootstrap del cluster
- Deploy masivo
- Limpieza

## 📚 docs/
Documentación del proyecto:
- Arquitectura
- Diagramas
- Guías paso a paso

## 🧪 Casos de uso
- Pruebas de CI/CD
- Laboratorio de Kubernetes
- Simulación de entornos productivos
- Práctica de observabilidad
- Testing de microservicios
