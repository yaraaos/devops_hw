terraform {
  backend "s3" {
    bucket         = "terraform-state-lesson-8-9-yara-goit-02"
    key            = "lesson-8-9/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks-lesson-8-9"
    encrypt        = true
  }
}
