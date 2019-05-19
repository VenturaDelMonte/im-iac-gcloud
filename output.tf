
output "Master Address" {
    value = "${google_compute_address.master-address.address}"
}

output "All Addresses" {
    value = "${local.all-ips}"
}

output "Bastion Address" {
    value = "${local.bastion-host}"
}

output "Master Internal Address" {
    value = "${local.master-node}"
}

output "SSH Command" {
    value = "gcloud compute ssh ${var.ssh_user}@im-master --ssh-key-file=/Users/ventura/.ssh/gcloud_rsa -- -D 1080"
}
