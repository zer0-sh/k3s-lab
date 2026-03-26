#!/bin/bash
set -euo pipefail

echo "=== Limpieza del entorno K3s ==="
read -p "Esto eliminara K3s y todos los recursos. Continuar? (y/N): " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Cancelado."
  exit 0
fi

echo "[1/2] Desinstalando K3s..."
if [ -f /usr/local/bin/k3s-uninstall.sh ]; then
  /usr/local/bin/k3s-uninstall.sh
else
  echo "K3s no encontrado, saltando..."
fi

echo "[2/2] Limpiando kubeconfig..."
rm -f "$HOME/.kube/config"

echo "=== Limpieza completada ==="
