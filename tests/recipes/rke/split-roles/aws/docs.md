## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.53.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.0 |
| <a name="requirement_ssh"></a> [ssh](#requirement\_ssh) | 2.6.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws-ec2-upstream-master-nodes"></a> [aws-ec2-upstream-master-nodes](#module\_aws-ec2-upstream-master-nodes) | ../../../../../modules/infra/aws/ec2 | n/a |
| <a name="module_aws-ec2-upstream-worker-nodes"></a> [aws-ec2-upstream-worker-nodes](#module\_aws-ec2-upstream-worker-nodes) | ../../../../../modules/infra/aws/ec2 | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"ec2-test"` | no |
| <a name="input_server_nodes_count"></a> [server\_nodes\_count](#input\_server\_nodes\_count) | n/a | `number` | `3` | no |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | n/a | `string` | `"ubuntu"` | no |
| <a name="input_worker_nodes_count"></a> [worker\_nodes\_count](#input\_worker\_nodes\_count) | n/a | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances_private_ip"></a> [instances\_private\_ip](#output\_instances\_private\_ip) | n/a |
| <a name="output_instances_public_ip"></a> [instances\_public\_ip](#output\_instances\_public\_ip) | n/a |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | n/a |
| <a name="output_subnet"></a> [subnet](#output\_subnet) | n/a |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | n/a |
