# Install ansible and openshift package in Terraform Cloud
resource "null_resource" "install_ansible" {
  count = var.enable_kong ? 1 : 0
  provisioner "local-exec" {
    command = "python3 -m pip install --user ansible==2.9.14 openshift==0.11.2"
  }
  triggers = {
    build_number = timestamp()
  }
  depends_on = [google_container_cluster.gke]
}

# Run the Ansible playbook locally against the GKE Cluster
resource "null_resource" "run_ansible_playbook" {
  count = var.enable_kong ? 1 : 0
  provisioner "local-exec" {
    command = "export PATH=$PATH:$HOME/.local/bin ; export K8S_AUTH_KUBECONFIG=${abspath(local_file.kubeconfig.filename)} ; ansible-playbook ansible/playbooks/install-kong.yml"
  }
  triggers = {
    build_number = timestamp()
  }
  depends_on = [null_resource.install_ansible,local_file.kubeconfig]
} 
