# Terraform | Microsoft Azure - Preparatory steps

In order for Terraform to run operations on your behalf, you must [install and configure the Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).

## Example

#### macOS installation and setup

```bash
brew update && brew install azure-cli
```

```bash
az login
```

##### If there are other active subscriptions, run

```bash
az account set --subscription `SUBSCRIPTION_ID`
```