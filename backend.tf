terraform {
  backend "local" {
    path = "./terraform.tfstate"
    credentials = "./creds/serviceaccount.json"
  }
}

