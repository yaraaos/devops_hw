# 📘 Final DevOps Project
---

# 🚀 Опис проєкту

Цей проєкт демонструє побудову хмарної інфраструктури в **AWS** із використанням **Terraform (Infrastructure as Code)** та розгортання застосунку в **Kubernetes (EKS)**.

Реалізовано:

- Мережеву архітектуру (VPC)
- Безпеку (IAM, Security Groups)
- Kubernetes кластер (EKS)
- Контейнерний реєстр (ECR)
- Базу даних (RDS / Aurora)
- CI/CD (Jenkins)
- GitOps (Argo CD)
- Моніторинг (Prometheus / Grafana)
- Autoscaling

---

# 🏗 Архітектура

Інфраструктура включає:

✔ VPC  
✔ Public / Private Subnets  
✔ Internet Gateway  
✔ Route Tables  
✔ IAM Roles & Policies  
✔ EKS Cluster  
✔ Node Group (EC2)  
✔ ECR Repository  
✔ RDS / Aurora  
✔ Monitoring Stack  
✔ Argo CD  

---

# ⚙️ Технології

- AWS  
- Terraform  
- Kubernetes (EKS)  
- Helm  
- Docker  
- Jenkins  
- Argo CD  
- Prometheus  
- Grafana  

---

# 📂 Структура проєкту

^^^
Project/
├── main.tf
├── backend.tf
├── outputs.tf
│
├── modules/
│   ├── s3-backend/
│   ├── vpc/
│   ├── ecr/
│   ├── eks/
│   ├── rds/
│   ├── jenkins/
│   └── argo_cd/
│
├── charts/
│   └── django-app/
│
└── Django/
    ├── app/
    ├── Dockerfile
    ├── Jenkinsfile
    └── docker-compose.yaml
^^^

---

# ☁️ Terraform Backend

Для збереження Terraform state:

- **S3 Bucket**
- **DynamoDB (state locking)**

---

# 🔐 Безпека

Налаштовано:

✔ VPC із сегментацією  
✔ Security Groups  
✔ IAM Roles  
✔ IAM Policies  
✔ Least Privilege Principle  

---

# ☸ Kubernetes (EKS)

Розгорнуто:

✔ EKS Cluster  
✔ Managed Node Group  
✔ AWS VPC CNI  
✔ Metrics Server  

Перевірка стану:

^^^bash
kubectl get nodes
kubectl get pods -A
^^^

---

# 🐳 Docker

Застосунок контейнеризовано:

✔ Dockerfile  
✔ Docker Compose (локальне тестування)

---

# 📦 ECR

Контейнерні образи зберігаються в:

^^^
<account>.dkr.ecr.eu-central-1.amazonaws.com/<repository>
^^^

---

# 🔁 CI/CD (Jenkins)

Pipeline:

✔ Build Docker image  
✔ Push до ECR  
✔ Deploy у EKS  

---

# 🔄 GitOps (Argo CD)

Argo CD забезпечує:

✔ Декларативний деплой  
✔ Синхронізацію Helm charts  
✔ Контроль стану застосунків  

---

# 📊 Моніторинг

Розгорнуто:

✔ Prometheus  
✔ Grafana  

Grafana використовується для візуалізації метрик.

---

# 📈 Autoscaling

Налаштовано:

✔ Horizontal Pod Autoscaler (HPA)

---

# ⚠ Known Issues

Через обмеження AWS Free Tier (`t3.micro`) можливі:

- Затримки старту pod
- Періодичні помилки AWS VPC CNI (`failed to assign IP address`)

Це пов’язано з ресурсними обмеженнями інстансів.

---

# ✅ Результат

✔ Побудовано AWS інфраструктуру через Terraform  
✔ Використано модульну архітектуру  
✔ Розгорнуто EKS кластер  
✔ Налаштовано CI/CD  
✔ Реалізовано GitOps  
✔ Додано моніторинг  
✔ Налаштовано автомасштабування  

---

# 📎 Відтворення проєкту

## Terraform

^^^bash
terraform init
terraform apply
^^^

---

## Kubernetes

^^^bash
aws eks update-kubeconfig --region eu-central-1 --name <cluster-name>
kubectl get nodes
^^^

---

## Helm

^^^bash
helm upgrade --install django-app charts/django-app -n default
^^^

---

# 🎯 Висновок

Проєкт демонструє практичні навички:

- Infrastructure as Code  
- AWS Cloud  
- Kubernetes  
- CI/CD  
- GitOps  
- Monitoring  
- Scaling  
