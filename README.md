# modak-platform

Two-service app (payment + auth) running on EKS.
Infra via Terraform, deployments via GitHub Actions, monitoring via Prometheus + Grafana.

## Order of operations

### Step 1 — Bootstrap (run once)
Creates S3, DynamoDB, ECR.
```
cd infra/bootstrap
terraform init
terraform apply
```

### Step 2 — Main infra
Creates VPC + EKS cluster.
```
cd infra/envs/dev
terraform init
terraform plan
terraform apply
```
Takes ~15 minutes. After apply:
```
aws eks update-kubeconfig --name modak-dev --region ap-south-2
kubectl get nodes
```

### Step 3 — Deploy apps manually (first time)
```
kubectl apply -f shared/k8s/namespace.yml
kubectl apply -f payment-service/k8s/
kubectl apply -f auth-service/k8s/
kubectl apply -f shared/k8s/ingress.yml
kubectl get pods -n production
```

### Step 4 — Install monitoring
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f shared/k8s/monitoring/prometheus-values.yml
```

Access Grafana:
```
kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring
```
Open http://localhost:3000 — admin / Admin1234!

### Step 5 — Tear down (do this after every session)
```
cd infra/envs/dev
terraform destroy

cd infra/bootstrap
terraform destroy
```
Then verify in AWS Console: EC2, EKS, VPC, ECR, S3 all gone.
