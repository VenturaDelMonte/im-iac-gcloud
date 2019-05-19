
resource "google_compute_network" "im_vpc" {
  name                    = "${var.cluster_name}-${random_id.clusterid.hex}-vpc"
  auto_create_subnetworks = "false"
  description             = "IM Cluster VPC"
}

resource "google_compute_subnetwork" "im_subnet" {
  name          = "${var.cluster_name}-${random_id.clusterid.hex}-subnet"

  ip_cidr_range = "${var.subnet_cidr}"

  private_ip_google_access = true

  region        = "${var.region}"
  network       = "${google_compute_network.im_vpc.self_link}"
}

# resource "google_compute_router" "im_router" {
#   name    = "${var.cluster_name}-${random_id.clusterid.hex}-router"
#   network = "${google_compute_network.im_vpc.name}"
# }

# resource "google_compute_router_nat" "im_nat" {
#   name                               = "${var.cluster_name}-nat-${random_id.clusterid.hex}"
#   router                             = "${google_compute_router.im_router.name}"
#   region                             = "${var.region}"
#   nat_ip_allocate_option             = "AUTO_ONLY"
#   source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
#   subnetwork {
#     name = "${google_compute_subnetwork.im_subnet.self_link}"
#   }
# }

resource "google_compute_address" "master-address" {
  name = "${var.cluster_name}-${random_id.clusterid.hex}-master-addr"
}

resource "google_compute_firewall" "master-allow" {
  name    = "${var.cluster_name}-${random_id.clusterid.hex}-master-allow-ssh"
  network = "${google_compute_network.im_vpc.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["im-vm-master-${random_id.clusterid.hex}"]
}

resource "google_compute_firewall" "cluster-traffic" {
  name    = "${var.cluster_name}-${random_id.clusterid.hex}-allow-cluster"
  network = "${google_compute_network.im_vpc.self_link}"

  allow {
    protocol = "all"
  }

  priority = 800

  source_tags = [
    "im-cluster-${random_id.clusterid.hex}"
  ]
  source_ranges = [
    "${google_compute_subnetwork.im_subnet.ip_cidr_range}"
  ]
  target_tags = ["im-cluster-${random_id.clusterid.hex}"]
}

resource "google_compute_router" "im_router" {
  name    = "${var.cluster_name}-${random_id.clusterid.hex}-router"
  network = "${google_compute_network.im_vpc.name}"
}

resource "google_compute_router_nat" "im-nat" {
  name                               = "${var.cluster_name}-nat-${random_id.clusterid.hex}"
  router                             = "${google_compute_router.im_router.name}"
  region                             = "${var.region}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name = "${google_compute_subnetwork.im_subnet.self_link}"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
