locals {
    cluster_name = "${var.name}-cluster"
    kubernetes_version = "1.33"
    ip_range_pods = "pods"
    ip_range_services = "services"

    additional_labels = {
        deployed_by     = "terraform"
        environment     = "demo"
    }

}