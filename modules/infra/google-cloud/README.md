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
