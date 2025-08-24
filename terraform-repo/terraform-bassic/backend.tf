
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-thalt"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
  }
}
