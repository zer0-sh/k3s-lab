# TODO - K3s Dev Platform Lab

## GitHub repo setup
- [ ] Crear repo `zer0-sh/k3s-platform` en GitHub (si no existe)
- [ ] Hacer push de todo el proyecto al repo
- [ ] Agregar secret `DOCKERHUB_USERNAME` con valor `steven58380`
- [ ] Agregar secret `DOCKERHUB_TOKEN` con un Access Token de Docker Hub
- [ ] Agregar secret `SONAR_TOKEN` (token de SonarQube — generar en http://localhost:9001 > My Account > Security)
- [ ] Agregar secret `SONAR_HOST_URL` (URL publica del SonarQube o del cluster)
- [ ] Agregar secret `ARGOCD_AUTH_TOKEN` (`argocd account generate-token --account ci`)
- [ ] Agregar secret `ARGOCD_SERVER` (URL publica del servidor ArgoCD)
- [ ] Dar permisos de escritura al workflow: Settings > Actions > General > Workflow permissions > Read and write

## ArgoCD
- [x] Aplicar app de postgres en ArgoCD
- [x] Aplicar app de sonarqube en ArgoCD
- [ ] Configurar el repo en ArgoCD para que pueda hacer sync (Settings > Repositories > Connect repo)
- [ ] Verificar que las 4 apps (sample-app, infrastructure, postgres, sonarqube) esten en Synced/Healthy

## ArgoCD Image Updater
- [ ] Instalar: `kubectl apply -f infrastructure/argocd-image-updater/install.yaml`
- [ ] Aplicar annotations actualizadas: `kubectl apply -f argocd-apps/sample-app.yaml`
- [ ] Verificar que detecta nuevas imagenes en Docker Hub

## Pendientes de implementar
- [ ] Sealed Secrets — cifrar los secrets para que no queden en texto plano en el repo
- [ ] Horizontal Pod Autoscaler (HPA) para sample-app
- [ ] Network Policies — restringir trafico entre namespaces
- [ ] Velero — backup del cluster
- [ ] Kustomize overlays dev/prod

## Validaciones
- [ ] Probar que el CI pipeline (build) corre al hacer push a `apps/sample-app/docker/`
- [ ] Probar que el linter corre en PRs y pushes a main
- [ ] Probar que Trivy escanea la imagen y los manifiestos
- [ ] Probar que SonarQube ejecuta el analisis (verificar en http://localhost:9001)
- [ ] Probar que el rollback se dispara si una app queda unhealthy
- [ ] Verificar que Image Updater actualiza el deployment automaticamente
- [ ] Verificar que Grafana muestra metricas del cluster
- [ ] Verificar que Loki captura logs de todos los pods

## Capturas pendientes (docs/screenshots/)
- [ ] ArgoCD — Dashboard con las 4 apps
- [ ] GitHub Actions — Vista general de workflows
- [ ] GitHub Actions — Job Summary de Trivy
- [ ] Grafana — Dashboard de metricas del cluster
- [ ] Prometheus — Pagina de targets
- [ ] pgAdmin — Conectado a PostgreSQL
- [ ] SonarQube — Dashboard del proyecto
- [ ] Rollback — Job Summary del rollback
