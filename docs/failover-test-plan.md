# Failover Test Plan

This document describes a controlled failover validation plan for the TaskApp AWS Kops cluster.

No EC2 instance should be terminated until the exact target instance IDs and command are reviewed and explicitly approved.

## Risk Warning

Terminating EC2 instances can temporarily reduce cluster capacity or control-plane availability. Run this only after capturing current evidence and confirming the project can tolerate temporary disruption.

Do not terminate instances if:

- AWS credentials are expired or unavailable.
- Kops validation is already failing.
- TaskApp API health is failing.
- The cluster has fewer healthy nodes than expected.
- You have not confirmed the target instance IDs.

## Pre-Check Commands

```bash
kubectl get nodes -o wide
kops validate cluster --state=${KOPS_STATE_STORE}
curl -s https://api.axiomdlabs.online/api/health
kubectl -n taskapp get pods -o wide
```

## Identify Candidate Nodes

Identify one control-plane node and one worker node:

```bash
kubectl get nodes -o wide
```

Map Kubernetes node names to EC2 instance IDs. In this cluster, node names are EC2 instance IDs, for example `i-0123456789abcdef0`.

Confirm instance details before proposing failover:

```bash
aws ec2 describe-instances \
  --instance-ids <instance-id> \
  --query 'Reservations[].Instances[].{InstanceId:InstanceId,State:State.Name,PrivateIp:PrivateIpAddress,Tags:Tags}' \
  --output table
```

## Capture Before Evidence

Save:

```bash
kubectl get nodes -o wide
kops validate cluster --state=${KOPS_STATE_STORE}
kubectl -n taskapp get pods -o wide
kubectl -n taskapp get svc
kubectl -n taskapp get ingress
kubectl -n taskapp get pvc
curl -s https://api.axiomdlabs.online/api/health
```

## Controlled Failover Method

After approval only, terminate one selected EC2 instance:

```bash
aws ec2 terminate-instances --instance-ids <approved-instance-id>
```

Do not terminate multiple instances at the same time unless the cluster has already recovered from the previous action.

## Validation Commands

After termination, watch for replacement/recovery:

```bash
kubectl get nodes -o wide
kops validate cluster --state=${KOPS_STATE_STORE}
kubectl -n taskapp get pods -o wide
curl -s https://api.axiomdlabs.online/api/health
```

## Recovery and Cleanup Notes

If a node is cordoned or drained during testing:

```bash
kubectl uncordon <node-name>
```

If an Auto Scaling Group replaces the instance, confirm:

```bash
aws autoscaling describe-auto-scaling-groups --output table
kubectl get nodes -o wide
kops validate cluster --state=${KOPS_STATE_STORE}
```

Final evidence should include before and after node state, Kops validation, pod state, and API health.
