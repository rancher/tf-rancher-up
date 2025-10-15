# Downstream | AWS | EKS

This module is used to create a rancher-launched EKS downstream cluster.

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/downstream/aws/EKS
```

- Copy `terraform.tfvars.example` to `terraform.tfvars`
- Edit `terraform.tfvars`
  - Update the required variables:
    - Add the Rancher server URL as well an API token. The API token can be obtained by navigating through the Rancher UI -> Profile Icon -> Account and API Keys.
    - If you don't want to configure AWS credentials, create or define an existing cloud credential in Rancher using aws configure in above step, uncomment aws_access_key and aws_secret_key variables in terraform.


Execute the below commands to start deployment.

```bash
terraform init
terraform plan
terraform apply
```

Once the deployment is successful, the terraform code will display the successful creation message.

- Destroy the resources when cluster is no more needed.
```bash
terraform destroy
```