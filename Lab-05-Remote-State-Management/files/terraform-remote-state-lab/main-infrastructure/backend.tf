terraform {
  backend "s3" {
    bucket                      = "terraform-state-bucket-unique-12345"
    key                         = "infrastructure/terraform.tfstate"
    region                      = "us-east-1"
    dynamodb_table              = "terraform-state-lock-lab"
    encrypt                     = true
    # emulator settings
    endpoint                    = "http://localhost:5000"
    dynamodb_endpoint           = "http://localhost:5000"
    force_path_style            = true
    access_key                  = "test"
    secret_key                  = "test"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
  }
}
