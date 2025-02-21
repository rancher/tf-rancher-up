# Upstream | AWS | K3S

This module is used to establish a Rancher (local) management cluster using AWS and K3S.

Documentation can be found [here](./docs.md).

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/upstream/aws/k3s
```

- Copy `terraform.tfvars.example` to `terraform.tfvars`
- Edit `terraform.tfvars`
  - Update the required variables:
    -  `aws_region` to suit your region
    -  uncomment `instance_type` and change the instance type if needed.
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
terraform plan -var-file terraform.tfvars
terraform apply -var-file terraform.tfvars
```
The login details will be displayed in the screen once the deployment is successful. It will have the details as below.

```bash
rancher_hostname = "https://rancher.<xx.xx.xx.xx>.sslip.io"
rancher_password = "initial-admin-password"
```

- If storing multiple AWS credentials in `~/.aws/credentials`, set the profile when running terraform.

```bash
AWS_PROFILE=<profile name> terraform plan -var-file terraform.tfvars
AWS_PROFILE=<profile name> terraform apply -var-file terraform.tfvars
```

- Destroy the resources when cluster is no more needed.
```bash
terraform destroy -var-file terraform.tfvars
```
**IMPORTANT**: Please retire the services which are deployed using these terraform modules within 48 hours. Soon there will be automation to retire the service automatically after 48 hours but till that is in place it will be the users responsibility to not keep it running more than 48 hours.

### Notes

The user data automatically sets up each node for use with kubectl (also alias to k) and crictl when logged in.

See full argument list for each module in use:
  - [AWS](../../../../modules/infra/aws/ec2)
  - [K3S](../../../../modules/distribution/k3s)
  - [Rancher](../../../../modules/rancher)

### Known Issues