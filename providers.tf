#
# Providers Configuration
#

terraform {
  required_version = "~> 0.12"
  required_providers {
    aws     = "~> 3.4"
    local   = "~> 1.4"
    http    = "~> 1.2.0"
    azurerm = "~> 2.25.0"
  }
}

provider "aws" {
  region     = var.Region
  access_key = var.AccessKey
  secret_key = var.SecretKey
}

# # Using these data sources allows the configuration to be generic for any region.
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

