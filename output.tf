
output "master-address" {
    value = "${google_compute_address.master-address.address}"
}

output "all-addresses" {
    value = "${local.all-ips}"
}

output "bastion-address" {
    value = "${local.bastion-host}"
}

output "master-internal-address" {
    value = "${local.master-node}"
}

output "ssh-command" {
    value = "gcloud compute ssh ${var.ssh_user}@im-master --ssh-key-file=/Users/ventura/.ssh/gcloud_rsa -- -D 1080"
}
