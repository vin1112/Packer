
# Below variables are set with example values. Please adjust them accordingly.

project_id           = "prj-fgli-poc-01"
source_image_family  = "ubuntu-2204-lts"
zone                 = "asia-south1-a"
image_name           = "jenkins-hardened-os"
image_description    = "Created with HashiCorp Packer from Cloudbuild"
ssh_username         = "root"
tags                 = ["packer"]
network              = "automation-vpc"
subnetwork           = "automation-sb-01"