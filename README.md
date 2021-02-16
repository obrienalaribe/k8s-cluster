# cea-gcp-k8s
CEA Google Kubernetes Engine Clusters

## Description

This repository creates the following resources on Google Cloud Platform:
- One node pool with autoscaling
- One Kubernetes Cluster using the created node pool

The resources are planned and provisioned (applied) using [Terraform Cloud](https://app.terraform.io/app/MasterVentures).

Once the provisioning is done, it generates a kubeconfig file and installs ansible to run the ansible playbook afterwards,
all of this right in Terraform Cloud.

## Prerequisites

| Component | Description | Version |
| --- | --- | --- |
| Terraform | Provision GCP Resources | = 0.13.4 |

### Configure variables

Take a look at [vars.tf](vars.tf) and create a terraform.tfvars file, here's an example:

Create terraform.tfvars from terraform.tfvars.example and modify according to your needs.

```bash
cp terraform.tfvars.example terraform.tfvars
```

Regions Documentation: https://cloud.google.com/about/locations/#regions

### Create a Service Account

Create a new Service Account in IAM with the following roles:
- Kubernetes Engine Admin
- Compute Viewer
- Service Account User

## Getting Started

Create a new key in the IAM Console and store it in the root directory of the repository, export the variable GOOGLE_CLOUD_KEYFILE_JSON in order for Terraform to provision the resources as follow:

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

Once the Kubernetes is fully provisioned in GKE, the following Cloud-native technologies are installed and configured:
- [Kong](https://konghq.com), for API Gateway.
- [Vault](https://www.vaultproject.io), for Secret Management.
- [Consul](https://www.consul.io), for Vault's High Availability storage backend.
- [Rook](https://rook.io/), for Cloud-native storage to support ReadWriteMany volumes using [Rook NFS](https://rook.io/docs/rook/v1.5/nfs.html)

Also, a playbook runs against Kubernetes to configure Kong Ingress Rules as well as custom Rook NFS instance using [Ansible](https://www.ansible.com).

### API Gateway Configurations (Ingress Rules)

The list of configuration files that are being applied to set up Kong API Gateway can be found [here](ansible/playbooks/roles/install-k4k8s/files/ingress)

### Vault Operational considerations

Once Vault is fully installed there are some manual steps to be done in order to work with vault:

- [Initialize and unseal process](https://learn.hashicorp.com/tutorials/vault/kubernetes-raft-deployment-guide?in=vault/kubernetes#initialize-and-unseal-vault)
- [Configure Kubernetes authentication](https://learn.hashicorp.com/tutorials/vault/kubernetes-sidecar#configure-kubernetes-authentication)
- [Set secrets](https://learn.hashicorp.com/tutorials/vault/kubernetes-sidecar#set-a-secret-in-vault)


**The steps above are subject to be automated**

### Rook NFS Operation considerations

Once Rook is fully installed through Ansible, a Rook NFS instance gets created right away, which is defined [here](ansible/playbooks/roles/install-rook/files/nfs/nfs.yml) as well as Kubernetes StorageClasses. The following table documents the Storage Classes created as well as its respective Persistent Volume Claim, the relation must be One-to-One.

| StorageClass | Persistent Volume Claim | Size |
| --- | --- | --- |
| rook-nfs-sc-01 | cea-orderbook-maker-service-tatis-logs | 10Gi |
| rook-nfs-sc-02 | cea-orderbook-maker-service-shera-logs | 10Gi |
| rook-nfs-sc-03 | cea-orderbook-taker-service-tatis-logs | 10Gi |
| rook-nfs-sc-04 | cea-orderbook-taker-service-shera-logs | 10Gi |

**editing NFS Exports and StorageClass does cause a downtime, therefore pods accesing the ReadWriteMany must be manually deleted.**

Bear in mind that Rook NFS is only used for ReadWriteMany volumes. For ReadWriteOnce and ReadOnlyMany volumes, there is nothing additional to do. [Access Modes Documentation](https://cloud.google.com/kubernetes-engine/docs/concepts/persistent-volumes#access_modes)
