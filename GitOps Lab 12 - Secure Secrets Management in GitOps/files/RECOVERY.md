# Sealed Secrets recovery
1. Install the controller: kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.41.2/controller.yaml
2. Restore the key (from secure storage, NOT Git): kubectl apply -f sealed-secrets-key-backup.yaml
3. Restart: kubectl -n kube-system rollout restart deploy/sealed-secrets-controller
4. Verify: kubectl -n myapp get sealedsecrets  (Synced=True)
Backup is selected by label: kubectl -n kube-system get secret -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml
