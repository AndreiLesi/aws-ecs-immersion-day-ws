terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = local.region
  
  default_tags {
    tags = {
        Creator = "Andrei Lesi"
        Workshop = "ECS Immersion Day"
    }
  }
}