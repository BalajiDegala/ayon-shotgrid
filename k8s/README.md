# Kubernetes Deployments

This folder contains example Kubernetes manifests for the Shotgrid services.
Each deployment uses the Docker images tagged with the version defined in
`package.py` and expects a set of environment variables.

## Secrets and ConfigMaps

Create a secret with your AYON API key:

```sh
kubectl create secret generic shotgrid-secret \
  --from-literal=AYON_API_KEY=<your-api-key>
```

Create a ConfigMap providing the server URL and addon information:

```sh
kubectl create configmap shotgrid-config \
  --from-literal=AYON_SERVER_URL=https://ayon.example.com \
  --from-literal=AYON_ADDON_NAME=shotgrid \
  --from-literal=AYON_ADDON_VERSION=0.6.2+dev
```

## Deployments

Apply the manifests to start the services:

```sh
kubectl apply -f k8s/leecher-deployment.yaml
kubectl apply -f k8s/processor-deployment.yaml
kubectl apply -f k8s/transmitter-deployment.yaml
```

These services do not expose any network ports, so no additional `Service`
resources are required unless you want to manage them differently.
