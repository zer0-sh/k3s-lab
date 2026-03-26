#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== K3s Platform Bootstrap ==="

# 1. Instalar K3s
echo "[1/4] Instalando K3s..."
bash "$PROJECT_DIR/cluster/bootstrap/install-k3s.sh"

# 2. Esperar a que el cluster este listo
echo "[2/4] Esperando a que el cluster este listo..."
kubectl wait --for=condition=Ready nodes --all --timeout=120s

# 3. Instalar addons del cluster
echo "[3/4] Instalando addons del cluster..."
kubectl apply -f "$PROJECT_DIR/cluster/addons/metrics-server/"
kubectl apply -f "$PROJECT_DIR/cluster/addons/ingress-nginx/"
kubectl apply -f "$PROJECT_DIR/cluster/addons/cert-manager/"

# 4. Instalar ArgoCD
echo "[4/4] Instalando ArgoCD..."
kubectl apply -f "$PROJECT_DIR/infrastructure/argocd/namespace.yaml"
kubectl apply -f "$PROJECT_DIR/infrastructure/argocd/installation.yaml"

echo ""
echo "=== Bootstrap completado ==="
echo "Espera a que ArgoCD este listo y luego ejecuta:"
echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo ""
echo "Password de admin:"
echo '  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d'
