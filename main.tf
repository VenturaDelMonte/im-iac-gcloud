
provider "google" {
 credentials = "${file("account.json")}"
 project     = "${var.project}"
 region      = "${var.region}"
 zone        = "${var.zone}"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "random_id" "clusterid" {
  byte_length = "2"
}

## Cluster Pre-config hook
resource "null_resource" "cluster-preconfig-hook-stop-on-fail" {
  count = "${var.on_hook_failure == "fail" ? local.cluster_size : 0}"

  connection {
      host          = "${element(local.all-ips, count.index)}"
      user          = "${var.ssh_user}"
      private_key   = "${local.ssh_key}"
      agent         = "${local.ssh_agent}"
      bastion_host  = "${local.bastion-host}"
  }

  # Run cluster-preconfig commands
  provisioner "remote-exec" {
    inline = [
      "${local.hooks["cluster-preconfig"]}"
    ]
    on_failure = "fail"
  }
}
resource "null_resource" "cluster-preconfig-hook-continue-on-fail" {
  count = "${var.on_hook_failure != "fail" ? local.cluster_size : 0}"

  connection {
    host          = "${element(local.all-ips, count.index)}"
    user          = "${var.ssh_user}"
    private_key   = "${local.ssh_key}"
    agent         = "${local.ssh_agent}"
    bastion_host  = "${local.bastion-host}"
  }

  # Run cluster-preconfig commands
  provisioner "remote-exec" {
    inline = [
      "${local.hooks["cluster-preconfig"]}"
    ]
    on_failure = "continue"
  }
}

resource "null_resource" "deploy-config" {
  depends_on = ["null_resource.cluster-preconfig-hook-continue-on-fail", "null_resource.cluster-preconfig-hook-stop-on-fail"]
  count = "${local.processing_host_size}"

  connection {
    host          = "${element(local.processing-ips, count.index)}"
    user          = "${var.ssh_user}"
    private_key   = "${local.ssh_key}"
    agent         = "${local.ssh_agent}"
    bastion_host  = "${local.bastion-host}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo -n echo This will fail unless we have passwordless sudo access"
    ]
  }

  provisioner "file" {
    source = "${path.module}/scripts/deploy.sh"
    destination = "/tmp/deploy.sh"
  }

  provisioner "file" {
    content = "${local.broker-list}"
    destination = "/tmp/brokers.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /opt/ventura/.bootstrap_complete ]; do sleep 1; done",
      "sudo mv /tmp/deploy.sh /opt/ventura/framework/deploy.sh",
      "sudo chown ventura:ventura /opt/ventura/framework/deploy.sh",
      "chmod 755 /opt/ventura/framework/deploy.sh",
      "/opt/ventura/framework/deploy.sh > /opt/ventura/framework/deploy.log 2>&1",
      "sudo chown ventura:ventura /tmp/brokers.txt",
      "sudo sed 's/.$//' /tmp/brokers.txt"
    ]
  }
}

data "template_file" "kafka_broker_config" {
  template = "${file("${path.module}/config/server.properties")}"
  count = "${local.broker_size}"
  vars {
    broker_id = "${count.index}"
    broker_hostname = "${element(local.broker-nodes, count.index)}"
  }
}

resource "null_resource" "deploy-config-brokers" {
  depends_on = ["null_resource.cluster-preconfig-hook-continue-on-fail", "null_resource.cluster-preconfig-hook-stop-on-fail"]
  count = "${local.broker_size}"

  connection {
    host          = "${element(local.broker-nodes, count.index)}"
    user          = "${var.ssh_user}"
    private_key   = "${local.ssh_key}"
    agent         = "${local.ssh_agent}"
    bastion_host  = "${local.bastion-host}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo -n echo This will fail unless we have passwordless sudo access"
    ]
  }

  provisioner "file" {
    source = "${path.module}/scripts/deploy_kafka.sh"
    destination = "/tmp/deploy.sh"
  }

  provisioner "file" {
    content = "${element(data.template_file.kafka_broker_config.*.rendered, count.index)}"
    destination = "/tmp/server.properties"
  }

  provisioner "file" {
    content = "${local.broker-list}"
    destination = "/tmp/brokers.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /opt/ventura/.bootstrap_complete ]; do sleep 1; done",
      "sudo mv /tmp/deploy.sh /opt/ventura/framework/deploy.sh",
      "sudo chown ventura:ventura /opt/ventura/framework/deploy.sh",
      "chmod 755 /opt/ventura/framework/deploy.sh",
      "/opt/ventura/framework/deploy.sh > /opt/ventura/framework/deploy.log 2>&1"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /opt/ventura/framework/kafka/bin/kafka-server-start.sh ]; do sleep 1; done",
      "sudo mv /tmp/server.properties /opt/ventura/framework/kafka/config/",
      "sudo chown ventura:ventura /opt/ventura/framework/kafka/config/server.properties",
      "sudo chown ventura:ventura /tmp/brokers.txt",
      "sudo sed 's/.$//' /tmp/brokers.txt"
    ]
  }
}

resource "null_resource" "deploy-config-generator" {
  depends_on = ["null_resource.cluster-preconfig-hook-continue-on-fail", "null_resource.cluster-preconfig-hook-stop-on-fail"]
  count = "${local.generator_size}"

  connection {
    host          = "${element(local.generator-nodes, count.index)}"
    user          = "${var.ssh_user}"
    private_key   = "${local.ssh_key}"
    agent         = "${local.ssh_agent}"
    bastion_host  = "${local.bastion-host}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo -n echo This will fail unless we have passwordless sudo access"
    ]
  }

  provisioner "file" {
    source = "${path.module}/scripts/deploy_generator.sh"
    destination = "/tmp/deploy.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /opt/ventura/.bootstrap_complete ]; do sleep 1; done",
      "sudo mv /tmp/deploy.sh /opt/ventura/framework/deploy.sh",
      "sudo chown ventura:ventura /opt/ventura/framework/deploy.sh",
      "chmod 755 /opt/ventura/framework/deploy.sh",
      "/opt/ventura/framework/deploy.sh > /opt/ventura/framework/deploy.log 2>&1"
    ]
  }

  provisioner "file" {
    content = "${local.broker-list}"
    destination = "/tmp/brokers.txt"
  }
}

# resource "null_resource" "start-flink" {
#   depends_on = ["null_resource.deploy-config"]

#   connection {
#     host          = "${local.master-node}"
#     user          = "${var.ssh_user}"
#     private_key   = "${local.ssh_key}"
#     agent         = "${local.ssh_agent}"
#     bastion_host  = "${local.bastion-host}"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "/opt/ventura/framework/flink-build/bin/start-cluster.sh"
#     ]
#   }
  
# }


locals {
  cluster_size = "${1 + var.worker["quantity"] + var.broker["quantity"] + var.generator["quantity"]}"
  processing_host_size = "${1 + var.worker["quantity"]}"
  broker_size = "${var.broker["quantity"]}"
  generator_size = "${var.generator["quantity"]}"
  bastion-host  = "${google_compute_instance.master.network_interface.0.access_config.0.nat_ip}"
  master-node = "${google_compute_instance.master.network_interface.0.network_ip}"
  worker-nodes = ["${google_compute_instance.worker.*.network_interface.0.network_ip}"]
  broker-nodes = ["${google_compute_instance.broker.*.network_interface.0.network_ip}"]
  generator-nodes = ["${google_compute_instance.generator.*.network_interface.0.network_ip}"]

  broker-list = "${join(",", formatlist("%s:9092", local.broker-nodes))}"
  processing-ips = "${concat(list(local.master-node), local.worker-nodes)}"
  all-ips       = "${concat(list(local.master-node), local.worker-nodes, local.broker-nodes, local.generator-nodes)}"

  ssh_key_base64  = "${base64encode(tls_private_key.ssh.private_key_pem)}"
  ssh_key       = "${base64decode(local.ssh_key_base64)}"
  ssh_agent       = false

  hooks = {
      # Make sure to wait for image load to complete
      # Make sure bootstrap is done on all nodes before proceeding
      "cluster-preconfig" = [
        "while [ ! -f /opt/ventura/.bootstrap_complete ]; do sleep 1; done"
      ]
  }
}
