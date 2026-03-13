terraform {
  backend "s3" {
    bucket         = "nodejs-terraform-state-1234"
    key            = "nodejs/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}