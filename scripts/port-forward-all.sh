#!/bin/bash
set -euo pipefail

export KUBECONFIG=~/.kube/config-k3s

echo "=== Levantando port-forwards ==="

declare -A SERVICES=(
  ["ArgoCD"]="svc/argocd-server -n argocd 8080:443"
  ["Grafana"]="svc/grafana -n monitoring 3000:80"
  ["Prometheus"]="svc/prometheus-server -n monitoring 9090:80"
  ["Sample App"]="svc/sample-app -n sample-app 8081:80"
  ["Loki"]="svc/loki -n logging 3100:3100"
)

PIDS=()

cleanup() {
  echo ""
  echo "=== Deteniendo port-forwards ==="
  for pid in "${PIDS[@]}"; do
    kill "$pid" 2>/dev/null || true
  done
  echo "Listo."
  exit 0
}

trap cleanup SIGINT SIGTERM

for name in "${!SERVICES[@]}"; do
  kubectl port-forward ${SERVICES[$name]} &>/dev/null &
  PIDS+=($!)
  echo "  $name -> PID $!"
done

echo ""
echo "=== Servicios disponibles ==="
echo "  ArgoCD:     https://localhost:8080  (admin / ver password abajo)"
echo "  Grafana:    http://localhost:3000   (admin / admin)"
echo "  Prometheus: http://localhost:9090"
echo "  Sample App: http://localhost:8081"
echo "  Loki:       http://localhost:3100/ready"
echo ""
echo "Password ArgoCD:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 2>/dev/null | base64 -d && echo ""
echo ""
echo "Presiona Ctrl+C para detener todos los port-forwards"

wait
