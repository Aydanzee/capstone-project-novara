# TaskApp Operations Runbook

This runbook documents the key operational commands for managing, validating, troubleshooting, and cleaning up the TaskApp AWS Kubernetes deployment.

## Live Endpoints

- Frontend: https://taskapp.axiomdlabs.online
- API health: https://api.axiomdlabs.online/api/health

## Environment Setup

Set the required environment variables before running AWS, Kops, or Kubernetes commands:

```bash
export AWS_REGION=us-east-1
export AWS_DEFAULT_REGION=us-east-1
export KOPS_STATE_STORE=s3://capstone-project-novara-dev-kops-state-027355625786-us-east-1
export KOPS_CLUSTER_NAME=k8s.axiomdlabs.online
```

Authenticate with AWS using your approved access method, then export short-lived credentials for the active shell. The local capstone profile used during validation was `ts-capstone`; replace it with the profile name assigned for your own environment.

```bash
aws login --profile <profile-name> --region us-east-1
eval "$(aws configure export-credentials --profile <profile-name> --format env)"
aws sts get-caller-identity
```

Confirm Kubernetes context:

```bash
kubectl config current-context
kubectl config use-context k8s.axiomdlabs.online
```

## CI Validation Scope

GitHub Actions validates code only for this capstone: Terraform formatting/init/validation, Kubernetes manifest rendering, and Docker image builds. CI does not deploy infrastructure, does not require AWS credentials, and does not replace the manual controlled deployment and cleanup procedures in this runbook.

## Cluster Health Checks

Validate the Kops cluster:

```bash
kops validate cluster --state=${KOPS_STATE_STORE}
```

Check Kubernetes nodes:

```bash
kubectl get nodes -o wide
```

Check all system pods:

```bash
kubectl get pods -A
```

Check TaskApp workloads:

```bash
kubectl -n taskapp get pods -o wide
kubectl -n taskapp get svc
kubectl -n taskapp get ingress
kubectl -n taskapp get pvc
```

## Application Health Checks

Check frontend over HTTPS:

```bash
curl -I https://taskapp.axiomdlabs.online
```

Check API/database health:

```bash
curl -s https://api.axiomdlabs.online/api/health
```

Check HTTP-to-HTTPS redirect:

```bash
curl -I http://taskapp.axiomdlabs.online
curl -I http://api.axiomdlabs.online/api/health
```

## TLS Certificate Checks

Check certificate status:

```bash
kubectl -n taskapp get certificate
kubectl -n taskapp describe certificate taskapp-tls
```

Check cert-manager pods:

```bash
kubectl -n cert-manager get pods
```

## Ingress Controller Checks

Check NGINX Ingress Controller:

```bash
kubectl -n ingress-nginx get pods
kubectl -n ingress-nginx get svc ingress-nginx-controller
```

Get the AWS Load Balancer hostname:

```bash
kubectl -n ingress-nginx get svc ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

## Deployment Commands

Before applying manifests to a fresh cluster, create the runtime secret outside Git:

```bash
kubectl -n taskapp create secret generic taskapp-secret \
  --from-literal=DATABASE_PASSWORD='<replace-with-secure-password>' \
  --from-literal=SECRET_KEY='<replace-with-secure-secret-key>' \
  --dry-run=client -o yaml | kubectl apply -f -
```

Apply the AWS Kubernetes overlay:

```bash
kubectl apply -k k8s/overlays/aws
```

Watch rollout status:

```bash
kubectl -n taskapp rollout status deployment/postgres
kubectl -n taskapp rollout status deployment/backend
kubectl -n taskapp rollout status deployment/frontend
```

Restart backend deployment:

```bash
kubectl -n taskapp rollout restart deployment/backend
kubectl -n taskapp rollout status deployment/backend
```

Restart frontend deployment:

```bash
kubectl -n taskapp rollout restart deployment/frontend
kubectl -n taskapp rollout status deployment/frontend
```

## Recovery Tests

Delete backend pods and confirm the deployment recreates them:

```bash
kubectl -n taskapp delete pod -l app.kubernetes.io/name=backend
kubectl -n taskapp rollout status deployment/backend --timeout=5m
kubectl -n taskapp get pods -o wide
curl -s https://api.axiomdlabs.online/api/health
```

Delete the PostgreSQL pod and confirm PVC-backed recovery:

```bash
POSTGRES_POD=$(kubectl -n taskapp get pod -l app.kubernetes.io/name=postgres -o jsonpath='{.items[0].metadata.name}')
kubectl -n taskapp delete pod "$POSTGRES_POD"
kubectl -n taskapp rollout status deployment/postgres --timeout=5m
kubectl -n taskapp get pvc
curl -s https://api.axiomdlabs.online/api/health
```

## Database Backup Strategy

The current capstone validates PostgreSQL persistence through an AWS EBS-backed Kubernetes PVC. For production, add automated backups instead of relying only on persistent volume recovery.

Recommended production approach:

- Scheduled `pg_dump` Kubernetes CronJob writing encrypted backups to S3.
- EBS snapshots or AWS Backup policy for the PostgreSQL persistent volume.
- Regular restore testing with documented retention.

Documentation-only non-destructive example:

```bash
kubectl -n taskapp exec deploy/postgres -- pg_dump -U taskapp_user taskapp > taskapp-backup.sql
```

## Terraform Checks

Move into the Terraform directory:

```bash
cd terraform
```

Validate Terraform:

```bash
terraform fmt -recursive
terraform validate
terraform plan
```

Expected clean state after deployment:

```text
No changes. Your infrastructure matches the configuration.
```

## Cost Control

This capstone environment runs paid AWS resources including EC2 instances, NAT gateways, load balancers, EBS volumes, Route53, and public IPv4 resources.

Recommended practice:

1. Capture all evidence.
2. Submit the project.
3. Confirm the certificate/submission has been accepted.
4. Destroy nonessential AWS resources immediately after completion.

## Cleanup Procedure

Delete the Kops cluster first:

```bash
kops delete cluster --name ${KOPS_CLUSTER_NAME} --state=${KOPS_STATE_STORE} --yes
```

Then destroy Terraform-managed infrastructure:

```bash
cd terraform
terraform destroy
```

Important: do not manually delete Terraform state buckets before confirming all managed resources have been destroyed.

## Troubleshooting

If AWS CLI says credentials are expired, re-authenticate with your approved AWS access method and export fresh credentials. For example, using the local capstone profile:

```bash
aws login --profile ts-capstone --region us-east-1
eval "$(aws configure export-credentials --profile ts-capstone --format env)"
aws sts get-caller-identity
```

If kubectl points to Docker Desktop instead of AWS:

```bash
kubectl config get-contexts
kubectl config use-context k8s.axiomdlabs.online
```

If DNS does not resolve immediately:

```bash
dig taskapp.axiomdlabs.online +short
dig api.axiomdlabs.online +short
```

If TLS certificate is not ready:

```bash
kubectl -n taskapp describe certificate taskapp-tls
kubectl -n taskapp get certificaterequest,order,challenge
```
