
variable "project" {
    default = "incremental-migration"
}

variable "service_account_email" {
  description = "The service account email address to attach to all compute instances, leave blank to use the default service account"
  default = ""
}

variable "cluster_name" {
    default = "im-cluster"
}

variable "region" {
  default = "europe-north1"
}
variable "zone" {
  default = "a"
}

variable "ssh_user" {
  default = "ventura"
}

variable "ssh_key" {
  default = ""
}

variable "password" {
  description = "Password for the initial admin user; blank to generate"
  default     = ""
}

variable "image" {
  default = {
    project = "ubuntu-os-cloud"
    family = "ubuntu-1804-lts"
  }
}

variable "master" {
  type = "map"

  default = {
    machine_type        = "n1-custom-8-16384"
    disk_size           = 10
    boot_disk_type      = "pd-standard"
    hostname            = "master"
    preemptible         = false
    allow_restart       = false
  }
}

variable "worker" {
  type = "map"

  default = {
    machine_type        = "n1-standard-16"
    disk_size           = 10
    quantity            = 12
    boot_disk_type      = "pd-standard"
    scratch_disk_interface = "NVME"
    hostname            = "worker"
    preemptible         = false
    allow_restart       = false
  }
}

variable "subnet_cidr" {
  description = "VPC subnetwork CIDR "
  default = "10.20.0.0/20"
}

variable "on_hook_failure" {
  description = "Behavior when hooks fail. Anything other than `fail` will `continue`"
  default     = "fail"
}