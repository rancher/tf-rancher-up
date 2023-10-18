## Usage

```bash
terraform init -upgrade ; terraform apply -target=module.google-compute-engine.tls_private_key.ssh_private_key -target=module.googlecompute-engine.local_file.private_key_pem -target=module.google-compute-engine.local_file.public_key_pem -auto-approve ; terraform apply -auto-approve
```

- Destroy the resources when finished
```bash
terraform destroy --auto-approve
```

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.75.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_google-compute-engine"></a> [google-compute-engine](#module\_google-compute-engine) | ../../compute-engine | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | The number of nodes | `number` | `2` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"example-rancher"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | `"<PROJECT_ID>"` | no |
| <a name="input_region"></a> [region](#input\_region) | Google Region to create the resources | `string` | `"us-west2"` | no |
| <a name="input_startup_script"></a> [startup\_script](#input\_startup\_script) | Script that will run when the VMs start | `string` | `"export DEBIAN_FRONTEND=noninteractive ; curl -sSL https://releases.rancher.com/install-docker/20.10.sh | sh - ; sudo usermod -aG docker ubuntu ; newgrp docker ; sudo sysctl -w net.bridge.bridge-nf-call-iptables=1 ; sleep 180"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances_private_ip"></a> [instances\_private\_ip](#output\_instances\_private\_ip) | Google Compute Engine Intances Private IPs |
| <a name="output_instances_public_ip"></a> [instances\_public\_ip](#output\_instances\_public\_ip) | Google Compute Engine Intances Public IPs |
