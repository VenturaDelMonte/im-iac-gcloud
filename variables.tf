
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
  default = "c"
}

variable "ssh_user" {
  default = "ventura"
}

variable "ssh_key" {
  default = ""
}

variable "image" {
  default = {
    project = "debian-cloud"
    family = "debian-9"
  }
}

variable "master" {
  type = "map"

  default = {
    #machine_type        = "n1-custom-8-24576"
    machine_type        = "n1-standard-8"
    disk_size           = 15
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
    quantity            = 8
    boot_disk_type      = "pd-standard"
    scratch_disk_interface = "NVME"
    hostname            = "worker"
    preemptible         = false
    allow_restart       = false
  }
}

variable "broker" {
  type = "map"

  default = {
    machine_type        = "n1-standard-16"
    disk_size           = 10
    quantity            = 4
    boot_disk_type      = "pd-standard"
    scratch_disk_interface = "NVME"
    hostname            = "broker"
    preemptible         = false
    allow_restart       = false
  }
}

variable "generator" {
  type = "map"

  default = {
    machine_type        = "n1-custom-16-32768"
    disk_size           = 10
    quantity            = 4
    boot_disk_type      = "pd-standard"
    hostname            = "generator"
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