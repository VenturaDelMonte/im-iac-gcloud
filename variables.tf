
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
    machine_type        = "n1-standard-1"
    disk_size           = 10
    hostname            = "master"
  }
}

variable "worker" {
  type = "map"

  default = {
    machine_type        = "n1-standard-1"
    disk_size           = 10
    quantity            = 1
    hostname            = "worker"
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