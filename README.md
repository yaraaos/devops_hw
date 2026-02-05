# 🚀 Lesson 7 — Kubernetes + EKS + Terraform

Цей проєкт є виконанням **домашнього завдання Lesson 7**  
та демонструє повний цикл розгортання застосунку **Django + PostgreSQL**
у **Amazon EKS** з використанням **Terraform, Helm та Kubernetes**.

---

## 📌 Архітектура рішення

- **AWS EKS** — керований Kubernetes-кластер
- **Terraform** — Infrastructure as Code
- **Helm** — встановлення PostgreSQL та Django
- **Amazon EBS CSI Driver** — Persistent Volumes
- **Application Load Balancer** — доступ до Django
- **PostgreSQL (StatefulSet)** — база даних з PVC

---

## 📁 Структура репозиторію

```text
lesson-7/
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── README.md
├── charts/
│   └── django-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
│           ├── configmap.yaml
│           └── hpa.yaml
├── modules/
│   ├── vpc/
│   ├── eks/
│   ├── ecr/
│   └── s3-backend/
└── terraform.tfstate
```
---

## 🛠 Використані інструменти

- Terraform
- AWS CLI
- kubectl
- Helm
- Amazon EKS
- Amazon EBS CSI Driver

---

## ☁️ Розгортання інфраструктури (Terraform)
1️⃣ Ініціалізація Terraform
```terraform init```

2️⃣ Перевірка плану
```terraform plan```

3️⃣ Застосування конфігурації
```terraform apply -auto-approve```


Terraform створює:

- VPC + Subnets
- EKS Cluster
- Node Group
- ECR
- S3 backend + DynamoDB lock

---

## ☸ Підключення до Kubernetes
```bash
aws eks update-kubeconfig \
  --region eu-central-1 \
  --name lesson-7-eks
```

Перевірка:

```bash
kubectl get nodes
```

Очікувано: **усі ноди у статусі** ```Ready```

---

## 💾 Встановлення Amazon EBS CSI Driver

EBS CSI Driver необхідний для роботи PersistentVolume.

Перевірка стану:
```bash
kubectl get pods -n kube-system | grep ebs
```

Очікувано:

```ebs-csi-controller``` — **Running**

```ebs-csi-node``` — **Running**

---

## 🐘 Встановлення PostgreSQL (Helm)
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```
```bash
helm upgrade --install db bitnami/postgresql \
  --set auth.username=django_user \
  --set auth.password=django_password \
  --set auth.database=django_db
```

Перевірка:
```bash
kubectl get pods
kubectl get pvc
```

Очікувано:

- ```db-postgresql-0``` — **Running**
- PVC — **Bound**

---

## 🐍 Розгортання Django застосунку
```bash
helm upgrade --install django-app ./charts/django-app
```

Перевірка:
```bash
kubectl get pods
kubectl get svc
```
---

## 🌐 Доступ до застосунку

Отримання LoadBalancer URL:
```bash
kubectl get svc django-app-django
```

Або:
```bash
LB=$(kubectl get svc django-app-django -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "http://$LB"
```
---

## 🔍 Перевірка працездатності
```bash
kubectl get pods
kubectl get pvc
kubectl get nodes
```

Очікувано:

- всі pod-и — **Running**
- PostgreSQL використовує PVC
 - Django доступний через LoadBalancer

---

## ✅ Результат

✔️ EKS кластер створено
✔️ Node Group працює
✔️ EBS CSI Driver активний
✔️ PostgreSQL використовує Persistent Volume
✔️ Django розгорнутий та доступний
✔️ Infrastructure as Code реалізовано через Terraform

---

## 🧾 Висновок

Дане домашнє завдання демонструє повноцінне production-like розгортання
хмарної інфраструктури з використанням сучасних DevOps практик:
Terraform, Kubernetes, Helm та AWS.
