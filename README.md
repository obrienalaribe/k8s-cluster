# cea-gcp-k8s
CEA Google Kubernetes Engine Clusters

## Description

This repository creates the following resources on Google Cloud Platform:
- One node pool with autoscaling
- One Kubernetes Cluster using the created node pool 

The resources are planned and provisioned (applied) using [Terraform Cloud](https://app.terraform.io/app/masterventures).

Once the provisioning is done, it generates a kubeconfig file and installs ansible to run the ansible playbook afterwards,
all of this right in Terraform Cloud.

## Prerequisites

| Component | Description | Version |
| --- | --- | --- |
| Terraform | Provision GCP Resources | => 0.13 |

### Configure variables

Take a look at [vars.tf](vars.tf) and create a terraform.tfvars file, here's an example:

Create terraform.tfvars

```bash
# Provider Vars
project = "vivid-plateau-278712"
region = "us-east1"
zone = "us-east1-b"

# GKE Vars
gke_cluster_name = "cea-k8s"
gke_node_pool_name = "cea-k8s-node-pool"
gke_node_pool_machine_type = "n2-standard-2"

# Hashicorp Vars
hashicorp_release_name = "cea"
consul_replicas = 2
```

Regions Documentation: https://cloud.google.com/about/locations/#regions

### Create a Service Account

Create a new Service Account in IAM with the following roles:
- Kubernetes Engine Admin
- Compute Viewer
- Service Account User

## Getting Started

Create a new key in the IAM Console and store it in the root directory of the repository, export the variable GOOGLE_CLOUD_KEYFILE_JSON 
in order for Terraform to provision the resources as follow:

```bash
export GOOGLE_CLOUD_KEYFILE_JSON=$(cat terraform-cloud.json)
```

Download providers: 

```bash
terraform init
```

### Deploy the infrastructure

```bash
terraform plan
```

```bash
terraform apply
```

### Destroy the infrastructure

```bash
terraform destroy
```

## Cluster Configuration Management

Once the Kubernetes is fully provisioned in GKE, a set of Helm charts are installed in the cluster:
- [Kong](https://konghq.com), for API Gateway.
- [Vault](https://www.vaultproject.io), for Secret Management.
- [Consul](https://www.consul.io), for Vault's High Availability storage backend.

Also, a playbook runs against Kubernetes to configure Kong Ingress Rules using [Ansible](https://www.ansible.com).

### API Gateway Configurations (Ingress Rules)

The list of configuration files that are being applied to set up Kong API Gateway can be found [here](ansible/playbooks/roles/install-k4k8s/files/ingress)

### Vault Operational considerations

Once Vault is fully installed there are some manual steps to be done in order to work with vault:

- [Initialize and unseal process](https://learn.hashicorp.com/tutorials/vault/kubernetes-raft-deployment-guide?in=vault/kubernetes#initialize-and-unseal-vault)
- [Configure Kubernetes authentication](https://learn.hashicorp.com/tutorials/vault/kubernetes-sidecar#configure-kubernetes-authentication)
- [Set secrets](https://learn.hashicorp.com/tutorials/vault/kubernetes-sidecar#set-a-secret-in-vault)


**The steps above are subject to be automated**
