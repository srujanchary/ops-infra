terraform {
  backend "s3" {
    bucket = "mancave-dev"
    region = "us-east-1"
  }
}

