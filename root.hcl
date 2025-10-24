# Set S3 backend for persisting TF state file remotely, ensure bucket already exits
# And that AWS user being used by TF has read/write perms
remote_state {
  backend = "s3"
  config = {
    region  = "us-east-1"
    profile = "default"
    encrypt = true
    key     = "terragrunt-deployment/${path_relative_to_include()}/terraform.tfstate"
    bucket  = "schenktech-terraform-state"
  }
}


generate "backend"{
  path      = "backend-generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

terraform {
  backend "s3" {}
  required_version = ">=1.0"
}
EOF
}

generate "provider" {
  path      = "providers-generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    onepassword = {
      source = "1Password/onepassword"
      version = "1.4.0"
    }

  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      deployed_by = "terraform"
      project = "cloudflare-terraform"
    }
  }
}

provider "onepassword" {
  # Users OP_ACCOUNT environment variable.
  # Env var set in ~/.zshrc
}

EOF
}

generate "op-data" {
  path      = "op-generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "onepassword_vault" "private" {
  name = "Homelab"
}

data "onepassword_item" "cf_api_token" {
  vault = data.onepassword_vault.private.uuid
  title = "cloudflare-all-dns"
}
EOF
}


