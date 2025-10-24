include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git@github.com:BillSchenk/terraform-modules.git?ref=null/null_resource/v1.0.0"
}

inputs = {
  bucket_name = "schenktech-test-bucket"
}