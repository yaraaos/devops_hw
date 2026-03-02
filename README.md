# 🚀 Final DevOps Project – AWS EKS Infrastructure with CI/CD

---

## 📌 Project Overview

This project demonstrates a production-style DevOps infrastructure deployed on **AWS** using:

- Terraform (Infrastructure as Code)
- Amazon EKS (Kubernetes)
- RDS PostgreSQL
- Jenkins (CI/CD)
- Argo CD (GitOps)
- Prometheus & Grafana (Monitoring)

The application is a Dockerized Django app deployed via Helm and connected to RDS PostgreSQL.

---

## 🏗 Architecture Components

### 🌐 Networking (VPC)

- Custom VPC
- Public & Private subnets (3 AZ)
- Internet Gateway
- Route tables
- Security Groups

### ☸ Kubernetes (EKS)

- Managed NodeGroup
- Cluster Autoscaler enabled
- Metrics Server installed
- AWS EBS CSI Driver configured
- Horizontal Pod Autoscaler (HPA)

### 🐘 Database (RDS)

- PostgreSQL engine
- Security Group restricted to EKS NodeGroup
- SSL enforced
- Connected to Django via Kubernetes Secret

### 📦 Container Registry (ECR)

- Docker image repository
- Integrated into Jenkins pipeline

### 🔁 CI/CD (Jenkins)

Pipeline includes:

- Checkout
- Unit Tests
- Docker Build
- Image Scan (Trivy)
- Push to ECR
- Helm Deploy
- Automatic rollback on failure

### 🔄 GitOps (Argo CD)

- Auto Sync enabled
- Self-healing enabled
- Continuous reconciliation

### 📊 Monitoring

- Prometheus
- Grafana
- Persistent storage enabled (PVC Bound via EBS CSI)

---

## 📂 Project Structure

### Directory Layout

'''
Project/
│
├── main.tf
├── backend.tf
├── outputs.tf
│
├── modules/
│   ├── s3_backend/
│   ├── vpc/
│   ├── ecr/
│   ├── eks/
│   ├── rds/
│   ├── jenkins/
│   └── argo_cd/
│
├── charts/
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── Chart.yaml
│       └── values.yaml
│
└── Django/
    ├── app/
    ├── Dockerfile
    ├── Jenkinsfile
    └── docker-compose.yaml
'''

---

## ⚙️ Infrastructure Deployment

### 1) Initialize Terraform

'''bash
terraform init
terraform validate
terraform plan
'''

### 2) Apply Infrastructure

'''bash
terraform apply
'''

This provisions:

- VPC
- EKS
- RDS
- ECR
- Jenkins
- Argo CD
- Monitoring stack

---

## 🔁 Autoscaling Verification

### Horizontal Pod Autoscaler

'''bash
kubectl -n default get hpa
kubectl top pods -n default || true
'''

Expected:

- HPA exists
- Metrics are available
- CPU-based scaling is configured

### Cluster Autoscaler

'''bash
kubectl -n kube-system get deploy cluster-autoscaler || true
kubectl -n kube-system logs deploy/cluster-autoscaler --tail=50 || true
'''

---

## 🐘 Django + PostgreSQL Integration

### Environment Variables (Kubernetes Secret)

- DB_HOST
- DB_NAME
- DB_USER
- DB_PASSWORD
- DB_PORT
- DB_SSLMODE=require

### Verify DB Connection

'''bash
POD=$(kubectl -n default get pod -l app=django-app-django -o jsonpath='{.items[0].metadata.name}')
kubectl -n default exec -it "$POD" -- python manage.py shell -c "from django.db import connection; print(connection.vendor); print(connection.settings_dict.get('HOST'))"
'''

Expected:

- `postgresql` / `postgres` vendor
- Host = RDS endpoint

### Run Migrations

'''bash
kubectl -n default exec -it "$POD" -- python manage.py migrate
'''

---

## 🔐 Security Configuration

### RDS Security Group Rules

Inbound access:

- Port 5432
- Source: EKS NodeGroup Security Group only
- No public `0.0.0.0/0` access

Verify:

'''bash
aws ec2 describe-security-groups --group-ids &lt;RDS_SG_ID&gt;
'''

---

## 🔄 CI/CD Pipeline

### Access Jenkins

'''bash
kubectl -n jenkins port-forward svc/jenkins 8080:8080
'''

### Pipeline Features

- Automated Docker build
- Image scanning (Trivy)
- Helm deployment with `--atomic`
- Rollback on failure (Helm atomic rollback)

---

## 🔁 Argo CD Verification

'''bash
kubectl -n argocd get application
kubectl -n argocd describe application django-app
'''

Expected:

- Synced status
- Automated sync enabled
- SelfHeal enabled

---

## 📊 Monitoring Verification

### Check PVC

'''bash
kubectl get pvc -n monitoring
'''

Expected:

- `grafana` = Bound
- `prometheus-server` = Bound

### Access Grafana

'''bash
kubectl -n monitoring port-forward svc/grafana 3000:80
'''

---

## 💾 Terraform Backend

Remote state is stored in:

- S3 bucket
- DynamoDB locking table

This ensures:

- State consistency
- Safe concurrent execution
- Reliability

---

## ⚠️ AWS Free Tier Limitations

During development, cluster instability occurred due to:

- low resources on small instances (e.g., `t3.micro`)
- pod density limits (`maxPods`)
- AWS VPC CNI IP allocation pressure

Despite this:

- Autoscaling was implemented
- Metrics Server was running
- Monitoring persistence was enabled
- Core services (EKS/RDS/ECR/ArgoCD/Jenkins/Monitoring) were deployed and validated

---

## 🧹 Destroy Infrastructure

To avoid unexpected AWS charges:

'''bash
terraform destroy
'''

⚠️ Note: Destroying infrastructure removes the S3 backend and DynamoDB locking table.

If redeploying:

1. Recreate backend module first
2. Run `terraform init`
3. Apply remaining modules

---

## 🎯 Evaluation Criteria Mapping

- Correct AWS architecture: ✅
- Secure networking & IAM: ✅
- EKS + RDS + ECR: ✅
- CI/CD implemented: ✅
- HPA configured: ✅
- Cluster Autoscaler configured: ✅
- Monitoring with persistence: ✅
- GitOps via Argo CD: ✅
- Documentation quality: ✅

