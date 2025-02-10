# Upstream | AWS | RKE2

This module is used to establish a Rancher (local) management cluster using AWS and RKE2.

Documentation can be found [here](./docs.md).

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/upstream/aws/rke2
```

- Copy `terraform.tfvars.example` to `terraform.tfvars`
- Edit `terraform.tfvars`
  - Update the required variables:
    -  `aws_region` to suit your region
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  Recommended: `spot_instances` can be set to `true` to use spot instances
- Check your AWS credentials are configured in `~/.aws/credentials`, terraform will use these by default. Refer the [`aws configure`](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-methods) command on how to do this.
- If you don't want to configure AWS credentials using `aws configure` in above step, uncomment `aws_access_key` and `aws_secret_key` in `terraform.tfvars` and input the required keys there.
- If an HA cluster need to be deployed, change the `instance_count` variable to 3 or more.
- There are more optional variables which can be tweaked under `terraform.tfvars`.

**NOTE** you may need to use ` terraform init -upgrade` to upgrade provider versions

Execute the below commands to start deployment.

```bash
terraform init
terraform plan
terraform apply
```
The login details will be displayed in the screen once the deployment is successful. It will have the details as below.

```bash
rancher_hostname = "https://rancher.<xx.xx.xx.xx>.sslip.io"
rancher_password = "initial-admin-password"
```

- If storing multiple AWS credentials in `~/.aws/credentials`, set the profile when running terraform.

```bash
AWS_PROFILE=<profile name> terraform plan
AWS_PROFILE=<profile name> terraform apply
```

- Destroy the resources when cluster is no more needed.
```bash
terraform destroy
```
**IMPORTANT**: Please retire the services which are deployed using these terraform modules within 48 hours. Soon there will be automation to retire the service automatically after 48 hours but till that is in place it will be the users responsibility to not keep it running more than 48 hours.

### Notes

The user data automatically sets up each node for use with kubectl (also alias to k) and crictl when logged in.

See full argument list for each module in use:
  - [AWS](../../../../modules/infra/aws/ec2)
  - [RKE2](../../../../modules/distribution/rke2)
  - [Rancher](../../../../modules/rancher)

### Known Issues
- Terraform plan shows below warnings which can be ignored:

```bash
Warning: Value for undeclared variable

The root module does not declare a variable named "ssh_private_key_path" but a value was found in file "terraform.tfvars". If you meant to use this value, add a "variable" block to the configuration.

Invalid attribute in provider configuration

with module.rancher_install.provider["registry.terraform.io/hashicorp/kubernetes"],
on ../../../../modules/rancher/provider.tf line 7, in provider "kubernetes":
7: provider "kubernetes" {
```
- Terraform apply shows below warnings and errors. Please rerun terraform apply again, and it will be successful[(Issue #22)](#22).

```bash
Warning: 

Helm release "rancher" was created but has a failed status. Use the `helm` command to investigate the error, correct it, then run Terraform again.

Error: 1 error occurred:
* Internal error occurred: failed calling webhook "validate.nginx.ingress.kubernetes.io": failed to call webhook: Post "https://rke2-ingress-nginx-controller-admission.kube-system.svc:443/networking/v1/ingresses?timeout=10s": no endpoints available for service "rke2-ingress-nginx-controller-admission"
```
