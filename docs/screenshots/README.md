# Screenshot Evidence Index

This directory contains screenshot evidence for the final TaskApp capstone submission.

| Filename | Evidence to capture |
|---|---|
| `live-frontend-https.png` | `https://taskapp.axiomdlabs.online` loaded successfully over HTTPS |
| `api-health-https.png` | `https://api.axiomdlabs.online/api/health` showing healthy database connectivity |
| `kops-cluster-ready.png` | Terminal output from `kops validate cluster` showing the cluster is ready |
| `aws-kops-nodes.png` | Terminal output from `kubectl get nodes -o wide` |
| `taskapp-pods-running.png` | Terminal output from `kubectl -n taskapp get pods -o wide` |
| `cert-manager-ready.png` | Terminal output from `kubectl -n taskapp get certificate` |

The terminal-style screenshots were rendered from the captured command evidence stored in `docs/evidence/`.
