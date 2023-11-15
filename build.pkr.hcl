packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.1"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "test-image" {
  project_id                  = "prj-fgli-poc-01"
  source_image_family         = "ubuntu-2204-lts"
  zone                        = "asia-south1-a"
  image_name = "jenkins-bootstrap"
  image_description           = "Created with HashiCorp Packer from Cloudbuild"
  ssh_username                = "root"
  tags                        = ["packer"]
  network =  "automation-vpc"
  subnetwork = "automation-sb-01"
  // omit_external_ip = true
  // use_internal_ip = true
}

build {
  sources = ["sources.googlecompute.test-image"]
   provisioner "shell" {
   script = "install-jenkins.sh"
  }
  provisioner "shell" {
   script = "setup-jenkins.sh"
  }
  provisioner "shell" {
  script = "install-plugins.sh"
  }
  provisioner "shell" {
  script = "confirm-jenkins-url.sh"
  }
  provisioner "file" {
  source = "HelloWorld.xml"
  destination = "/root/HelloWorld.xml"
}
  provisioner "shell" {
  script = "post-install.sh"
  }

}