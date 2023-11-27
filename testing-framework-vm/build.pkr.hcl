
  packer {
    required_plugins {
      googlecompute = {
        version = ">= 1.1.1"
        source  = "github.com/hashicorp/googlecompute"
      }
    }
  }


  source "googlecompute" "test-image" {
    project_id          = var.project_id
    source_image_family = var.source_image_family
    zone                = var.zone
    image_name          = var.image_name
    image_description   = var.image_description
    ssh_username        = var.ssh_username
    tags                = var.tags
    network             = var.network
    subnetwork          = var.subnetwork
  }

  build {
    sources = ["sources.googlecompute.test-image"]
    provisioner "shell" {
      script = "os-hardening.sh"
    }
    provisioner "shell" {
      script = "testing-framework.sh"
    }

  }

