# CI/CD: Terraform + Jenkins + Helm + Argo CD (EKS)

Цей проєкт реалізує повний CI/CD цикл для застосунку в Kubernetes (EKS):
- Інфраструктура створюється через **Terraform**
- **Jenkins** запускає pipeline з **Jenkinsfile**
- Pipeline:
  1) збирає Docker image з Dockerfile
  2) пушить image в **AWS ECR**
  3) оновлює `image.tag` (і `image.repository`) в `values.yaml` **Helm-репозиторію**
  4) пушить зміни в `main`
- **Argo CD** відслідковує Helm-репозиторій і автоматично деплоїть нову версію в кластер

---

## Репозиторії

### Repo A (APP repo)
- `django-app-goit` — містить `Dockerfile` + `Jenkinsfile`
- Jenkins бере код звідси і будує образ

### Repo B (HELM repo)
- `helm-charts-goit` — містить Helm chart (наприклад `django-app/values.yaml`)
- Jenkins оновлює тут `values.yaml` (repository/tag)

---

## Архітектура CI/CD (схема)

```text
          (push code)
Dev  ───────────────► GitHub Repo A (App)
                         │
                         │ Jenkins Pipeline (Jenkinsfile)
                         ▼
                    Build image (Kaniko in K8s)
                         │
                         ▼
                    Push to AWS ECR
                         │
                         ▼
        Update Helm Repo B: values.yaml (image.tag/repository)
                         │
                         ▼
                 GitHub Repo B (Helm charts)
                         │
                         ▼
                 Argo CD watches Repo B
                         │
                         ▼
            Sync/Deploy to EKS (new image tag)

``` 
---

## Вимоги

- AWS account + EKS cluster
- kubectl налаштований (доступ до EKS)
- awscli налаштований
- Terraform встановлений
- Jenkins встановлений в кластері (через Helm з Terraform)
- Argo CD встановлений (через Helm)

  ---

# 1) Як застосувати Terraform

У папці проєкту з Terraform (де main.tf)

### 1.1 Ініціалізація
```terraform init```

### 1.2 Перевірка плану
```terraform plan```

### 1.3 Застосування
```terraform apply -auto-approve```

### 1.4 Перевірити ресурси в кластері
```
kubectl get nodes
kubectl get ns
kubectl get pods -A
```
---

## 2) Jenkins: як перевірити Job / Pipeline
### 2.1 Отримати доступ до Jenkins UI
### Перевірити namespace Jenkins (якщо інший — заміни)
```
kubectl get ns | grep jenkins
```

### Знайти сервіс Jenkins
```
kubectl -n jenkins get svc
```

### Port-forward (локально)
```
kubectl -n jenkins port-forward svc/jenkins 8080:8080
```

Відкрити браузер:
- http://localhost:8080

### Отримати admin password (якщо Helm chart створює secret)
```
kubectl -n jenkins get secret jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 -d; echo
```

### 2.2 Jenkins credentials (обовʼязково)

В Jenkins UI:
**Manage Jenkins → Credentials → (global) → Add Credentials**

Створити:
### AWS credentials (Secret text)
- **ID:** ```aws-access-key-id```
- **Secret:** ваш AWS Access Key ID
- **ID:** ```aws-secret-access-key```
- **Secret:** ваш AWS Secret Access Key
- 
### GitHub Token (для push у Helm repo)
- **ID:** github-token
- **Secret:** GitHub PAT (classic) з правами:
  - repo (обов’язково)
  - (опційно) workflow

### 2.3 Запуск Pipeline
Pipeline налаштований як:
- **Pipeline script from SCM**
- Repo: ```https://github.com/<YOU>/django-app-goit.git```
- Branch: ```main```
- Script Path: ```Jenkinsfile```

### Build Now
Натиснути **Build Now** і дивитись **Console Output**

### 2.4 Як зрозуміти, що Jenkins job успішний
В Console Output має бути:
- Kaniko build **Succeeded**
- Push в ECR **OK**
- ```git clone helm repo``` **OK**
- ```git commit``` **OK**
- ```git push origin main``` **OK**

  ---

## 3) Як побачити результат в Argo CD
### 3.1 Доступ до Argo CD UI
```
kubectl -n argocd get svc
kubectl -n argocd port-forward svc/argo-cd-argocd-server 8081:443
```
Відкрити:
- https://localhost:8081

### Отримати пароль Argo CD
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

Login:
- user: admin
- password: (команда вище)

### 3.2 Перевірити застосунок в Argo CD
В UI:
- Applications → ваш app (наприклад django-app)
- Переконатись:
  - Repo = Helm repo (```helm-charts-goit```)
  - Path = chart path (наприклад ```django-app``` або ```charts/django-app```)
  - Sync status = **Synced**
  - Health = **Healthy**
 
    ---

## 4) Як швидко перевірити результат деплою в кластері
### Подивитися pods у namespace застосунку (якщо окремий namespace)
```
kubectl get pods -A | grep django
```
### Перевірити деплоймент
```
kubectl get deploy -A | grep django
```
### Перевірити, який image реально використовується
```
kubectl get deploy -n <NAMESPACE> <DEPLOYMENT_NAME> -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
```

