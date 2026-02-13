# 🚀 Terraform AWS RDS Модуль

Універсальний Terraform-модуль для створення **AWS RDS бази даних** або **Aurora Cluster** через єдину гнучку конфігурацію.

Модуль підтримує:

✅ Звичайну RDS instance (PostgreSQL / MySQL)  
✅ Aurora Cluster  
керовані прапором `use_aurora`.

---

## ✨ Можливості модуля

- 🔁 **Перемикання режиму розгортання**
  - `use_aurora = true` → створюється **Aurora Cluster + writer instance**
  - `use_aurora = false` → створюється **одна aws_db_instance**

- 🧱 **Спільні ресурси (створюються завжди)**
  - DB Subnet Group
  - Security Group
  - Parameter Group

- ⚙ **Повна параметризація**
  - Engine та версія БД
  - Клас інстансу
  - Multi-AZ
  - Користувацькі DB parameters

---

## 📦 Структура модуля

```text 
modules/rds/
├── rds.tf        # Створення звичайної RDS instance
├── aurora.tf     # Створення Aurora Cluster + instances
├── shared.tf     # Subnet Group, Security Group, Parameter Group
├── variables.tf  # Вхідні змінні
└── outputs.tf    # Виводи модуля
``` 

---

## 🛠 Приклад використання

```hcl 
module "rds" {
  source = "./modules/rds"

  use_aurora     = false
  engine         = "postgres"
  engine_version = "14"

  instance_class = "db.t3.micro"
  multi_az       = false

  db_name  = "appdb"
  username = "dbadmin"
  password = var.db_password

  subnet_ids = module.vpc.private_subnet_ids
  vpc_id     = module.vpc.vpc_id

  allowed_cidr_blocks = ["10.0.0.0/16"]

  parameters = {
    max_connections = "200"
    log_statement   = "none"
    work_mem        = "4096"
  }
}
``` 

---

## 🔧 Вхідні змінні

| Змінна | Тип | Значення за замовчуванням | Опис |
|--------|------|---------------------------|------|
| `use_aurora` | `bool` | `false` | Перемикання між Aurora та звичайною RDS |
| `engine` | `string` | `"postgres"` | Engine бази даних (`postgres`, `mysql`, …) |
| `engine_version` | `string` | `"14"` | Версія engine |
| `instance_class` | `string` | `"db.t3.micro"` | Клас інстансу |
| `multi_az` | `bool` | `false` | Увімкнути Multi-AZ |
| `db_name` | `string` | `"appdb"` | Початкова база даних |
| `username` | `string` | `"dbadmin"` | Master username |
| `password` | `string` | — | Master password (**sensitive**) |
| `subnet_ids` | `list(string)` | — | Subnet IDs для DB Subnet Group |
| `vpc_id` | `string` | — | VPC ID для Security Group |
| `allowed_cidr_blocks` | `list(string)` | `["0.0.0.0/0"]` | Дозволені CIDR (тимчасовий дефолт) |
| `parameters` | `map(string)` | `{}` | Параметри DB Parameter Group |

---

## 🔄 Перемикання типу БД

### ▶ Звичайна RDS Instance

```hcl 
use_aurora = false
``` 

**Створюється:**

✅ `aws_db_instance`

---

### ▶ Aurora Cluster

```hcl 
use_aurora = true
``` 

**Створюється:**

✅ `aws_rds_cluster`  
✅ `aws_rds_cluster_instance` (writer)

---

## ⚙ Зміна Engine бази даних

### PostgreSQL

```hcl 
engine         = "postgres"
engine_version = "14"
``` 

---

### MySQL

```hcl 
engine         = "mysql"
engine_version = "8.0"
``` 

---

## 💪 Зміна класу інстансу

```hcl 
instance_class = "db.t3.small"
``` 

Приклади:

- `db.t3.micro` → тестування / мінімальні витрати  
- `db.t3.small` → невеликі навантаження  
- `db.t3.medium` → більші навантаження  

---



## ✅ Перевірка 

Модуль перевірено через:

```bash 
terraform plan -var="use_aurora=true"
terraform plan -var="use_aurora=false"
``` 

Очікувана поведінка:

- Aurora режим → у плані з’являється `aws_rds_cluster`
- Standard режим → у плані з’являється `aws_db_instance`

Без необхідності `terraform apply`.

---

👨‍💻 **Terraform DevOps Homework – Універсальний RDS Модуль**
