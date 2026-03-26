#!/bin/bash
set -euo pipefail

echo "=== Instalando K3s ==="
curl -sfL https://get.k3s.io | sh -

echo "=== Verificando instalacion ==="
sudo kubectl get nodes

echo "=== Configurando kubeconfig ==="
mkdir -p "$HOME/.kube"
sudo cp /etc/rancher/k3s/k3s.yaml "$HOME/.kube/config"
sudo chown "$(id -u):$(id -g)" "$HOME/.kube/config"
export KUBECONFIG="$HOME/.kube/config"

echo "=== K3s instalado correctamente ==="
