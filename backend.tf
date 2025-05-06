terraform {
  backend "s3" {
    bucket = "tfbucketforstate"
    key    = "terraform/backend"
    region = "us-east-1"
  }
}