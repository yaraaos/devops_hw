<pre>^^^markdown
# 🚀 Фінальний DevOps Проєкт – AWS EKS Інфраструктура з CI/CD

---

## 📌 Опис проєкту

Даний проєкт демонструє побудову production-рівня DevOps-інфраструктури в **AWS** з використанням:

- Terraform (Infrastructure as Code)
- Amazon EKS (Kubernetes)
- RDS PostgreSQL
- Jenkins (CI/CD)
- Argo CD (GitOps)
- Prometheus та Grafana (Моніторинг)

Застосунок — це Dockerized Django-додаток, який деплоїться через Helm та підключається до RDS PostgreSQL.

---

## 🏗 Компоненти архітектури

### 🌐 Мережева інфраструктура (VPC)

- Кастомна VPC
- Публічні та приватні підмережі (3 Availability Zones)
- Internet Gateway
- Таблиці маршрутизації
- Security Groups

---

### ☸ Kubernetes (EKS)

- Managed NodeGroup
- Налаштований Cluster Autoscaler
- Встановлений Metrics Server
- AWS EBS CSI Driver
- Horizontal Pod Autoscaler (HPA)

---

### 🐘 База даних (RDS)

- PostgreSQL
- Security Group обмежений доступом лише з EKS NodeGroup
- Примусове використання SSL
- Підключення через Kubernetes Secret

---

### 📦 Контейнерний реєстр (ECR)

- Репозиторій Docker-образів
- Інтеграція з Jenkins пайплайном

---

### 🔁 CI/CD (Jenkins)

Пайплайн включає:

- Checkout коду
- Unit тести
- Збірку Docker-образу
- Сканування образу (Trivy)
- Push в ECR
- Деплой через Helm
- Автоматичний rollback при помилці

---

### 🔄 GitOps (Argo CD)

- Увімкнений Auto Sync
- Увімкнений Self-Healing
- Безперервна синхронізація з Git

---

### 📊 Моніторинг

- Prometheus
- Grafana
- Персистентне зберігання через PVC (EBS CSI)

---

## 📂 Структура проєкту

### Структура директорій

^^^
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
^^^

---

## ⚙️ Розгортання інфраструктури

### 1) Ініціалізація Terraform

^^^bash
terraform init
terraform validate
terraform plan
^^^

---

### 2) Розгортання інфраструктури

^^^bash
terraform apply
^^^

Буде створено:

- VPC
- EKS
- RDS
- ECR
- Jenkins
- Argo CD
- Стек моніторингу

---

## 🔁 Перевірка автомасштабування

### Horizontal Pod Autoscaler

^^^bash
kubectl -n default get hpa
kubectl top pods -n default || true
^^^

Очікується:

- HPA створений
- Метрики доступні
- Масштабування за CPU налаштоване

---

### Cluster Autoscaler

^^^bash
kubectl -n kube-system get deploy cluster-autoscaler || true
kubectl -n kube-system logs deploy/cluster-autoscaler --tail=50 || true
^^^

---

## 🐘 Підключення Django до PostgreSQL

### Змінні середовища (Kubernetes Secret)

- DB_HOST
- DB_NAME
- DB_USER
- DB_PASSWORD
- DB_PORT
- DB_SSLMODE=require

---

### Перевірка підключення до БД

^^^bash
POD=$(kubectl -n default get pod -l app=django-app-django -o jsonpath='{.items[0].metadata.name}')
kubectl -n default exec -it "$POD" -- python manage.py shell -c "from django.db import connection; print(connection.vendor); print(connection.settings_dict.get('HOST'))"
^^^

Очікується:

- vendor = postgresql
- host = endpoint RDS

---

### Запуск міграцій

^^^bash
kubectl -n default exec -it "$POD" -- python manage.py migrate
^^^

---

## 🔐 Налаштування безпеки

### Security Group для RDS

Вхідні правила:

- Порт 5432
- Джерело: Security Group EKS NodeGroup
- Заборонено 0.0.0.0/0

Перевірка:

^^^bash
aws ec2 describe-security-groups --group-ids &lt;RDS_SG_ID&gt;
^^^

---

## 🔄 CI/CD

### Доступ до Jenkins

^^^bash
kubectl -n jenkins port-forward svc/jenkins 8080:8080
^^^

---

### Можливості пайплайну

- Автоматична збірка Docker
- Сканування образів
- Helm-деплой з `--atomic`
- Автоматичний rollback

---

## 🔁 Перевірка Argo CD

^^^bash
kubectl -n argocd get application
kubectl -n argocd describe application django-app
^^^

Очікується:

- Статус Synced
- Увімкнений Auto Sync
- Увімкнений SelfHeal

---

## 📊 Перевірка моніторингу

### PVC

^^^bash
kubectl get pvc -n monitoring
^^^

Очікується:

- grafana — Bound
- prometheus-server — Bound

---

### Доступ до Grafana

^^^bash
kubectl -n monitoring port-forward svc/grafana 3000:80
^^^

---

## 💾 Terraform Backend

Стан Terraform зберігається в:

- S3 bucket
- DynamoDB таблиці блокування

Забезпечує:

- Консистентність state
- Захист від паралельного виконання
- Надійність інфраструктури

---

## ⚠️ Обмеження AWS Free Tier

Під час розробки виникали нестабільності через:

- Обмежені ресурси t3.micro
- Невеликий обсяг пам’яті
- Навантаження на AWS VPC CNI

Незважаючи на це:

- Автомасштабування налаштоване
- Metrics Server працює
- Персистентність моніторингу реалізована
- Основні сервіси успішно розгорнуті

---

## 🧹 Видалення інфраструктури

Щоб уникнути зайвих витрат:

^^^bash
terraform destroy
^^^

⚠️ Увага: буде видалено S3 backend та DynamoDB таблицю.

Для повторного запуску:

1. Спочатку відновити backend модуль
2. Виконати terraform init
3. Далі terraform apply

---

## 🎯 Відповідність критеріям оцінювання

- Коректна AWS архітектура: ✅
- Безпека (VPC, IAM, SG): ✅
- EKS + RDS + ECR: ✅
- Реалізований CI/CD: ✅
- Налаштований HPA: ✅
- Налаштований Cluster Autoscaler: ✅
- Моніторинг з персистентністю: ✅
- GitOps через Argo CD: ✅
- Якісна документація: ✅
^^^</pre>
