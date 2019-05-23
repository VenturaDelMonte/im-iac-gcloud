data "google_compute_image" "base_compute_image" {
  project   = "${var.image["project"]}"
  family    = "${var.image["family"]}"
}

resource "google_compute_instance" "master" {
  name = "im-master"
  machine_type = "${var.master["machine_type"]}"
  zone = "${var.region}-${var.zone}"
  #hostname = "${var.master["hostname"]}.im-cluster"

  allow_stopping_for_update = true

  tags = ["im-vm-master-${random_id.clusterid.hex}", "im-cluster-${random_id.clusterid.hex}"]

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.base_compute_image.self_link}"
      size = "${var.master["disk_size"]}"
      type = "${var.master["boot_disk_type"]}"
    }
  }

  network_interface {
    subnetwork  = "${google_compute_subnetwork.im_subnet.self_link}"
    access_config {
      nat_ip = "${google_compute_address.master-address.address}"
    }
  }

  scheduling {
    preemptible = "${var.master["preemptible"]}"
    automatic_restart = "${var.master["allow_restart"]}"
  }

  can_ip_forward = true

  service_account {
    email = "${var.service_account_email}"
    scopes = ["compute-rw", "storage-ro", "logging-write", "monitoring"]
  }

  metadata_startup_script = <<EOF
""
#!/bin/bash
apt -y install cloud-init
rm -f /var/log/cloud-init.log
rm -Rf /var/lib/cloud/*
cloud-init -d init
cloud-init -d modules --mode=config
cloud-init -d modules --mode=final
"}
EOF

  metadata {
    sshKeys = <<EOF
${var.ssh_user}:${file(var.ssh_key)}
EOF
    user-data = <<EOF
#cloud-config
users:
- name: ventura
  groups: [ wheel ]
  sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
  shell: /bin/bash
  ssh-authorized-keys:
  - ${file(var.ssh_key)}
  - ${tls_private_key.ssh.public_key_openssh}
write_files:
- encoding: b64
  content: ${base64encode(file("${path.module}/config/bashrc"))}
  permissions: '0600'
  path: /home/ventura/.bashrc
- encoding: b64
  content: ${base64encode(file("${path.module}/config/ssh_config"))}
  permissions: '0400'
  path: /home/ventura/.ssh/config
- encoding: b64
  content: ${base64encode(file("${path.module}/config/profile"))}
  permissions: '0600'
  path: /home/ventura/.profile
- encoding: b64
  content: ${base64encode(file("${path.module}/scripts/bootstrap_master.sh"))}
  permissions: '0755'
  path: /opt/ventura/scripts/bootstrap.sh
- encoding: b64
  content: ${base64encode("${tls_private_key.ssh.private_key_pem}")}
  permissions: '0600'
  path: /home/ventura/.ssh/id_rsa
- encoding: b64
  content: ${base64encode("${tls_private_key.ssh.public_key_openssh}")}
  permissions: '0600'
  path: /home/ventura/.ssh/id_rsa.pub
runcmd:
- chown ventura:ventura /home/ventura/.ssh/id_rsa.pub
- chown ventura:ventura /home/ventura/.ssh/id_rsa
- chown ventura:ventura /home/ventura/.bashrc
- chown ventura:ventura /home/ventura/.profile
- chown ventura:ventura /home/ventura/.ssh/config
- chown -R ventura:ventura /home/ventura
- /opt/ventura/scripts/bootstrap.sh
EOF
  }
}

resource "google_compute_instance" "worker" {
  name = "${format("im-worker-%02d", count.index + 1)}"
  machine_type = "${var.worker["machine_type"]}"
  zone = "${var.region}-${var.zone}"
  count = "${var.worker["quantity"]}"
  hostname = "${format("im-worker-%02d.im-cluster", count.index + 1)}"

  allow_stopping_for_update = true

  tags = ["im-cluster-${random_id.clusterid.hex}", "im-worker-${random_id.clusterid.hex}"]

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.base_compute_image.self_link}"
      size = "${var.worker["disk_size"]}"
      type = "${var.worker["boot_disk_type"]}"
    }
  }

  scratch_disk {
    interface = "${var.worker["scratch_disk_interface"]}"  
  }

  scratch_disk {
    interface = "${var.worker["scratch_disk_interface"]}"  
  }

  scheduling {
    preemptible = "${var.worker["preemptible"]}"
    automatic_restart = "${var.worker["allow_restart"]}"
  }

  network_interface {
    subnetwork  = "${google_compute_subnetwork.im_subnet.self_link}"
    
  }

  can_ip_forward = true

  service_account {
    email = "${var.service_account_email}"
    scopes = ["storage-ro", "logging-write", "monitoring"]
  }

  metadata_startup_script = <<EOF
""
#!/bin/bash
apt -y install cloud-init
rm -f /var/log/cloud-init.log
rm -Rf /var/lib/cloud/*
cloud-init -d init
cloud-init -d modules --mode=config
cloud-init -d modules --mode=final
"}
EOF

  metadata {
    sshKeys = <<EOF
${var.ssh_user}:${file(var.ssh_key)}
EOF
    user-data = <<EOF
#cloud-config
users:
- name: ventura
  groups: [ wheel ]
  sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
  shell: /bin/bash
  ssh-authorized-keys:
  - ${tls_private_key.ssh.public_key_openssh}
write_files:
- encoding: b64
  content: ${base64encode(file("${path.module}/scripts/bootstrap_worker.sh"))}
  permissions: '0755'
  path: /opt/ventura/scripts/bootstrap.sh
- encoding: b64
  content: ${base64encode(file("${path.module}/config/bashrc"))}
  permissions: '0600'
  path: /home/ventura/.bashrc
- encoding: b64
  content: ${base64encode(file("${path.module}/config/ssh_config"))}
  permissions: '0400'
  path: /home/ventura/.ssh/config
- encoding: b64
  content: ${base64encode("${tls_private_key.ssh.private_key_pem}")}
  permissions: '0600'
  path: /home/ventura/.ssh/id_rsa
- encoding: b64
  content: ${base64encode("${tls_private_key.ssh.public_key_openssh}")}
  permissions: '0600'
  path: /home/ventura/.ssh/id_rsa.pub
- encoding: b64
  content: ${base64encode(file("${path.module}/config/profile"))}
  permissions: '0600'
  path: /home/ventura/.profile
runcmd:
- chown ventura:ventura /home/ventura/.ssh/id_rsa.pub
- chown ventura:ventura /home/ventura/.ssh/id_rsa
- chown ventura:ventura /home/ventura/.bashrc
- chown ventura:ventura /home/ventura/.ssh/config
- chown ventura:ventura /home/ventura/.profile
- chown -R ventura:ventura /home/ventura
- /opt/ventura/scripts/bootstrap.sh
EOF
  }
}