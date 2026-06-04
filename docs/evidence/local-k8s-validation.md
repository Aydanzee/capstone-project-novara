# Local Kubernetes Validation

Validation completed on Docker Desktop Kubernetes.

Checks performed:
- Applied manifests with `kubectl apply -k k8s/base`
- Verified backend, frontend, and Postgres pods are running
- Verified backend health endpoint returns healthy database connection
- Verified Postgres PVC is Bound
- Deleted Postgres pod and confirmed Kubernetes recreated it
- Deleted backend pods and confirmed Deployment recreated 2 healthy replicas
- Confirmed task data persisted after refresh/pod recovery
