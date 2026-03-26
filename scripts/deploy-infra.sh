#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Desplegando infraestructura ==="

echo "[1/3] Desplegando monitoring (Prometheus + Grafana)..."
kubectl apply -f "$PROJECT_DIR/infrastructure/monitoring/prometheus/"
kubectl apply -f "$PROJECT_DIR/infrastructure/monitoring/grafana/"

echo "[2/3] Desplegando logging (Loki)..."
kubectl apply -f "$PROJECT_DIR/infrastructure/logging/loki/"

echo "[3/3] Registrando apps en ArgoCD..."
kubectl apply -f "$PROJECT_DIR/argocd-apps/"

echo ""
echo "=== Infraestructura desplegada ==="
echo "Grafana: kubectl port-forward svc/grafana -n monitoring 3000:80"
echo "  Usuario: admin / Password: admin"
