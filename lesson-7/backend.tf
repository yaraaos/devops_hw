terraform {
  backend "s3" {
    bucket         = "terraform-state-lesson-7-yara-goit-02"
    key            = "lesson-7/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks-lesson-7"
    encrypt        = true
  }
}
