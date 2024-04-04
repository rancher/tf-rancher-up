# Downstream | AWS | RKE

This module is used to create a rancher-launched RKE downstream cluster.

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/downstream/aws/rke
```

- Copy terraform.tfvars.example to terraform.tfvars
- Edit terraform.tfvars
    - Update the required variables under:
        - Rancher server details:
            - Add the Rancher server URL as well as the API token and secret. The API token and secret can be obtained by navigating through the Rancher UI -> Profile Icon -> Account and API Keys.
        - AWS  specific configuration:
            - Make sure to uncomment and declare all variables under this section as per the requirements.
            - Check your AWS credentials are configured in ~/.aws/credentials, terraform will use these by default. Refer the aws configure command on how to do this.
            - If you don't want to configure AWS credentials using aws configure in above step, uncomment aws_access_key and aws_secret_key variables in terraform.tfvars and input the required keys there.
        - Cluster and node-pool specific configuration:
            - Mention the cluster name and the Kubernetes version as per requirement.
            - Please mention the names for node pools, the respective hostname prefix and the number of master and worker nodes as per requirement.

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
