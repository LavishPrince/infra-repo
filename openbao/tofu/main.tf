terraform {
  # 1. State Storage (S3-compatible Rust FS Bucket)
  required_version = ">= 1.7.0"
  backend "s3" {
    bucket                      = "infra-tofu-state"
    key                         = "infrastructure/prod.tfstate"
    region                      = "main" # Arbitrary string required by the S3 backend
    endpoint                    = "http://localhost:9000" # Your Rust storage URL
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    use_path_style              = true # Often required by self-hosted storage
  }

  encryption {
    key_provider "openbao" "my_bao" {
      transit_engine_path = "transit"
      key_name            = "tofu-state-key"

    }

    method "aes_gcm" "bao_method" {
      keys = key_provider.openbao.my_bao
    }

    # method "unencrypted" "fallback" {}
  
    # state {
    #   # 2. Add the fallback method to the list
    #   method   = method.aes_gcm.bao_method
    #   fallback { 
    #     method = method.unencrypted.fallback 
    #   }
    # }
    state {
      method   = method.aes_gcm.bao_method
      enforced = true
    }

    # Optional: Encrypt your plan files with the same key
    plan {
      method = method.aes_gcm.bao_method
    }
  }
}

provider "vault" {
  # Configure via VAULT_ADDR and VAULT_TOKEN env variables
}

variable "namespace" {
  type        = string
  description = "namespace where the secrets are configured"
  default     = "quation"
}

