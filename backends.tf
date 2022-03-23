terraform {
  cloud {
    organization = "Bestseller-dev"

    workspaces {
      name = "development"
    }
  }
}