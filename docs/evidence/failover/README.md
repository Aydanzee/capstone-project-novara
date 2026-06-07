# Failover Evidence Note

The files in this folder are failover pre-check attempt logs captured before any destructive node termination was approved.

The `kops-validate-before.txt`, `kubectl-nodes-before.txt`, and `taskapp-pods-before.txt` files show Kubernetes API timeout errors during the pre-check window. They should not be presented as successful failover validation.

Use `../kops-validate-cluster.txt` as the successful Kops cluster-ready evidence. That file shows all control-plane and worker nodes ready and ends with:

```text
Your cluster k8s.axiomdlabs.online is ready
```

The failover test plan intentionally says not to proceed if Kops validation or API access is already failing.
