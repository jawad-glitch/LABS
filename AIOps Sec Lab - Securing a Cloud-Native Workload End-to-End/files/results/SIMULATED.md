# Simulated / swapped - AIOps Sec Lab - Securing a Cloud-Native Workload End-to-End
- Calico: not installed; k3s built-in NetworkPolicy controller enforces the same objects (lab's own documented fallback).
- Gatekeeper/Kyverno: policies evaluated with their own engines offline (gator v3.23.1, kyverno CLI v1.19.2), not as in-cluster webhooks.
- cert-manager: certificates issued with OpenSSL from a private CA; cert-manager manifests schema-validated.
- Vault: dev server as a container with Kubernetes auth against the real k3d API; Vault Agent run as a container (injector equivalent).
- Falco: on the Docker host (modern eBPF); custom rule keyed on container.name; k8s context attached when exporting for Task 8.
Real: k3d/k3s v1.30.4, kube-bench, LocalStack 3.7.2 + Terraform 1.7.5 + Checkov + tfsec, Trivy v0.76.2, RBAC can-i, NetworkPolicy
enforcement, Vault v2.2.1, Falco 0.45.2, Isolation Forest.
