# Terraform | Google Cloud - Preparatory steps

In order for Terraform to run operations on your behalf, you must [install and configure the gcloud SDK tool](https://cloud.google.com/sdk/docs/install-sdk).

## Example

#### macOS installation and setup

```console
brew install --cask google-cloud-sdk
```

```console 
gcloud components install gke-gcloud-auth-plugin
```

```console 
gcloud init
```

```console 
gcloud auth application-default login
```

##### If there are other active accounts, run

```console 
gcloud config set account `ACCOUNT`
```

## It is also possible to specify a Service Account JSON file and use it directly in recipes

#### terraform.tfvars file example (k3s x Google Cloud)

```console
prefix                = "yourname"
project_id            = "xyz"
gcp_account_json      = "path/to/YOUR-SA-FILE.json"
region                = "europe-west8"
server_instance_count = 1
worker_instance_count = 1
rancher_hostname      = "yourname-rancher"
rancher_password      = "Yourpassword.123"
```
