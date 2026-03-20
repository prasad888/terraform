terraform {
  backend "s3" {
    bucket         = "prasad-s3-demo-xyz-1234" # change this
    key            = "prasad/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"   
    
  }
}