include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git@github.com:BillSchenk/terraform-modules.git?ref=aws/s3_bucket/v1.1.0"
}

inputs = {
  bucket_name = "schenktech-test-bucket"
}