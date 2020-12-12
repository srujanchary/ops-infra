terraform {
  backend "s3" {
    bucket = "mancave-dev"
    key    = "statefile/"
    region = "us-east-1"
  }
}

