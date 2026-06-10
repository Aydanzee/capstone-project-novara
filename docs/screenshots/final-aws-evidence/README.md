# Final AWS Evidence Screenshots

This folder contains sanitized screenshot evidence for the final DevOps capstone submission. The original raw screenshots remain in the repository root and were not modified.

## Screenshot Index

- `01-budget-alert.png` - Shows the AWS budget details for the capstone budget, including the $40.00 budget amount, current spend, and exceeded threshold alert.
- `03-auto-scaling-groups.png` - Shows the kOps Auto Scaling groups for control-plane, worker node, and bastion capacity, all at desired capacity with healthy instances.
- `04-load-balancer.png` - Shows the Network Load Balancer listener configuration, including TCP listeners for ports 80 and 443, target group forwarding, DNS name, and subnet mapping.
- `05-target-groups.png` - Shows the load balancer target groups, ports, target type, linked load balancers, and VPC ID for the capstone infrastructure.
- `06-nat-gateways.png` - Shows the three NAT Gateways in the VPC, each in the `Available` state with public connectivity.
- `10-live-frontend.png` - Shows the live HTTPS frontend at `taskapp.axiomdlabs.online` rendering the TeamFlow application.
- `11-live-api-health.png` - Shows the live API health endpoint at `api.axiomdlabs.online/api/health` returning `healthy` status with a connected database.

## Sanitization Notes

The sanitized copies blur AWS account identity details, the AWS account dropdown area, and visible account ID segments in ARNs where present. Technical evidence such as regions, service names, states, DNS names, VPC IDs, ports, budget amounts, and live URLs remains visible.
