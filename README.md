<a name="readme-top"></a>

  <h3 align="center">TF-RANCHER-UP</h3>

  <p align="center">
    Deploy Rancher in your desired Kubernetes distribution
    <br />
    <a href="./README.md"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/rancherlabs/tf-rancher-up/issues">Report Bug</a>
    ·
    <a href="https://github.com/rancherlabs/tf-rancher-up/issues">Request Feature</a>
  </p>
</div>

Table of Contents

- [About The Project](#about-the-project)
- [Built With](#built-with)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
    - [Git](#git)
    - [Terraform](#terraform)
  - [What's next](#whats-next)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
    - [Naming convention](#naming-convention)
    - [Design/Architecture](#designarchitecture)
    - [Testing](#testing)
- [License](#license)
- [Acknowledgments](#acknowledgments)


<!-- ABOUT THE PROJECT -->
## About The Project

This repository comprises reusable terraform [modules](./modules) to deploy Rancher, a complete software stack for teams adopting containers, on a Kubernetes cluster provisioned in any of the infrastructure/cloud platforms(AWS/VMware/Azure/GCP/DigitalOcean). Provisioning can be customized using different Kubernetes distributions(RKE/RKE2/K3S/EKS/AKS/GKE) and will be here by referred to as [recipes](./recipes). We can deploy upstream Kubernetes (cluster used only for running Rancher), deploy Rancher and Downstream Kubernetes (cluster used for workloads) using these terraform modules by stitching together various recipes.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Built With

Most of the codebase is using HCL(Hashicorp Configuration Language) and some portion is using cloud-init and bash scripts.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

To get started you can clone the git repository to a desired location in your local or remote computer.

  ```sh
  git clone  git@github.com:rancherlabs/tf-rancher-up.git
  ```

### Prerequisites

#### Git

Git should be installed on the local or remote computer which is used for cloning the repository as mentioned above. Git comes installed by default on most Mac and Linux machines . Please refer the git installation guide [here](https://github.com/git-guides/install-git) if you need help.

Git clone can be performed only after setting up the required ssh keys. Please refer [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) if you need help on this.

#### Terraform

Terraform should be installed on your local or remote computer where the repository is cloned.  Please refer [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) for installation instructions.

### What's next

Once you clone the repository please go to the desired [recipes](./recipes) path and start configuring required environmental variables for your platform. Please refer the [README](./recipes/README.md) under [recipes](./recipes) for details about how to start provisioning.


<!-- ROADMAP -->
## Roadmap

- [x] Add support for RKE2 and K3S
- [ ] Add support for DO as infrastructure provider
- [x] Option to deploy Rancher Prime

See the [open issues](https://github.com/rancherlabs/tf-rancher-up/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CONTRIBUTING -->
## Contributing

Check out this [file](https://github.com/rancherlabs/tf-rancher-up/blob/main/CONTRIBUTING.md) for all the information about how you can contribute to this project.

#### Naming convention

- Ensure the new names chosen for the variables follow the pattern found in existing modules.

- No abbreviated variable names. 

**Example: tkt vs ticket, ct vs count.**

#### Design/Architecture

- Use native Terraform functionality as much as possible.

- Avoid usage of heavy logic in shell scripts outside of Terraform resources.

- Use of `null_resources` Tf resource as a last resort, and that too with minimal functionality/logic.

- Use of proper/sane defaults for all the variables.

- Add validation for variables if possible.

**See the example of the Regions.**

- Any Recipe should run with just 1) terraform init 2) terraform apply 3) terraform destroy.

**Justify the opposite if necessary.**

**Providing just the Cloud credentials.**

- The Recipe should itself be runnable as a Module.

- No hard-coded values anywhere in the code. Any value used should be via a variable only.

- All configurable values from the modules should be exposed via Recipe. 

**Almost a copy-paste of variables.tf from Module to Recipe.**

- Ensure any timeouts available are exposed via config variables.

- Ensure the code is generic enough that it's reusable elsewhere.

#### Testing

- Add tests where possible with various use cases.

**See existing modules.**

- Ensure they run in the Pipeline.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- LICENSE -->
## License

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

<p align="right">(<a href="#readme-top">back to top</a>)</p>
