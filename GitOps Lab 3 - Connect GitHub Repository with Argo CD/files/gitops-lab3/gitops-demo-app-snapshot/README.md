# GitOps Demo Application

Kubernetes manifests for a simple nginx application managed by Argo CD.

## Structure
- `deployment.yaml` - Nginx deployment configuration
- `service.yaml` - Service to expose the application
- `namespace.yaml` - Namespace definition
- `kustomization.yaml` - Kustomize configuration

## Deployment
Deployed by Argo CD (automated sync, prune, self-heal).
