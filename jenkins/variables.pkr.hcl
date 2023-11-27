    variable "project_id" {
    type    = string
    default = ""
    }

    variable "source_image_family" {
    type    = string
    default = "ubuntu-2204-lts"
    }

    variable "zone" {
    type    = string
    default = "asia-south1-a"
    }

    variable "image_name" {
    type    = string
    default = "jenkins-hardened-os"
    }

    variable "image_description" {
    type    = string
    default = "Jenkins image created by Hashicorp packer"
    }

    variable "ssh_username" {
    type    = string
    default = "root"
    }

    variable "tags" {
    type    = list(string)
    default = ["packer"]
    }

    variable "network" {
    type    = string
    default = "default"
    }

    variable "subnetwork" {
    type    = string
    default = ""
    }
