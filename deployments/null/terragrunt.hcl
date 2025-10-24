include "root" {
  path = find_in_parent_folders("root.hcl")
}


# add a random comment to force cache invalidation
terraform {
  source = "git@github.com:BillSchenk/terraform-modules.git?ref=null/null_resource/v1.0.1"
}

inputs = {
  bucket_name = "schenktech-test-bucket"
}