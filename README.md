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



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#built-with">Built With</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#whats-next">Whats next</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



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


### Whats next

Once you clone the repository please go to the desired [recipes](./recipes) path and start configuring required environmental variables for your platform. Please refer the [README](./README.md) under [recipes](./recipes) for details about how to start provisioning.



<!-- ROADMAP -->
## Roadmap

- [x] Add support for RKE2 and K3S
- [ ] Add support for DO as infrastructure provider
- [ ] Option to deploy Rancher Prime


See the [open issues](https://github.com/rancherlabs/tf-rancher-up/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

#### Workflow to open a Pull Request:


- Clone or pull all changes

 ```sh
  git clone  git@github.com:rancherlabs/tf-rancher-up.git

  OR

  git pull --all (if already cloned)
  ```
     This step internally does: git remote add origin https://github.com/rancherlabs/tf-rancher-up.git

- Fork the project from [here](https://github.com/rancherlabs/tf-rancher-up/fork)

```sh
 cd <cloned directory path>
 git remote add mycopy <forked-url>
 ```
     Example: git remote add mycopy git@github.com:<your_github_id>/tf-rancher-up.git`

- Create your Feature Branch
```sh
 git checkout -b <feature-branch-name>
```
- Make changes you wanted in the code.

- Use `terraform fmt` to lint and format any changes that occured.
```sh
 terraform fmt -recursive .
```
- If the changes relate to the README, update the content for changed modules with `terraform-docs`:
```bash
 terraform-docs markdown .
```
- Commit your Changes

```sh
 git commit -m "concise and meaningful commit messages about what is changing"
```
- Push to the Branch

```sh
 git push mycopy <feature-branch-name>
```
- Open a Pull Request providing any testing and change details from [here](https://github.com/rancherlabs/tf-rancher-up/compare)

- After the PR is merged, delete the branch `<feature-branch-name>`

- Dont push a branch to origin/main repository. Push only to forks.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License



<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Your Name - ajith.rajan@suse.com

Project Link: [https://github.com/rancherlabs/tf-rancher-up](https://github.com/rancherlabs/tf-rancher-up)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments


<p align="right">(<a href="#readme-top">back to top</a>)</p>