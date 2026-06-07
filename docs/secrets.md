# Runtime Secrets

TaskApp expects a Kubernetes Secret named `taskapp-secret` in the `taskapp` namespace.

The repository does not apply real secret values by default. `k8s/base/secret.example.yaml` is included only as a shape/example file with obvious placeholder values.

## Required Keys

`taskapp-secret` must contain:

- `DATABASE_PASSWORD`
- `SECRET_KEY`

## Create the Secret Outside Git

Create or update the runtime secret before applying manifests to a fresh cluster:

```bash
kubectl -n taskapp create secret generic taskapp-secret \
  --from-literal=DATABASE_PASSWORD='<replace-with-secure-password>' \
  --from-literal=SECRET_KEY='<replace-with-secure-secret-key>' \
  --dry-run=client -o yaml | kubectl apply -f -
```

This keeps sensitive values out of Git while preserving the manifest contract expected by the backend and PostgreSQL deployments.

## Production Options

For production, use a managed secret workflow such as:

- External Secrets Operator with AWS Secrets Manager
- Sealed Secrets
- SOPS-encrypted Kubernetes manifests
- A CI/CD secret injection step

Do not commit real AWS credentials, kubeconfigs, private keys, `.env` files, Terraform state, or runtime secret values.
