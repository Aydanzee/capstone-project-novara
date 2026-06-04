# Cost Analysis

This project should be treated as a temporary capstone lab. Build, validate, record evidence, submit, and destroy nonessential AWS resources immediately after submission.

## Budget Alert

Create an AWS Budget before provisioning infrastructure.

Recommended starter budget:

- Budget type: Cost budget
- Period: Monthly
- Amount: 50 USD
- Alert 1: 50% actual spend
- Alert 2: 80% actual spend
- Alert 3: 100% forecasted spend

Use the email address you actively monitor.

## Estimated Temporary AWS Costs

These are rough planning estimates for `us-east-1`. Actual costs vary by instance type, traffic, storage, public IPv4 usage, and how long resources stay online.

| Resource | Capstone usage | Rough temporary cost driver |
|----------|----------------|-----------------------------|
| EC2 instances | Kops control-plane and worker nodes | Hourly instance runtime |
| NAT Gateways | One per AZ for private subnets | Hourly NAT charge plus data processing |
| Load Balancer | Ingress traffic entry point | Hourly load balancer charge plus LCU usage |
| EBS volumes | Node/root disks and Postgres persistence | GB-month storage and snapshots |
| S3 buckets | Terraform state, Kops state, backups | Low storage cost unless logs/backups grow |
| DynamoDB | Terraform lock table | Usually minimal with on-demand billing |
| Route53 hosted zone | Domain DNS delegation | Monthly hosted zone charge |
| Public IPv4 | NAT gateways and load balancers | Hourly public IPv4 charge |

## Cost-Safe Operating Plan

1. Create AWS budget alerts first.
2. Review `terraform plan` before applying.
3. Keep the full HA cluster online only when testing or recording evidence.
4. Capture screenshots/logs immediately after validation.
5. Run Kops and Terraform cleanup after submission.

## Cleanup Reminder

Before considering the capstone complete, document and test cleanup commands in the runbook:

```bash
kops delete cluster --name <cluster-name> --yes
terraform destroy
```

Do not delete Terraform state buckets until all managed resources are confirmed destroyed.
