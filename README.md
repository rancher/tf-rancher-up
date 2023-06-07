<a name="readme-top"></a>

  <h3 align="center">TF-RANCHER-UP</h3>

  <p align="center">
    Deploy Rancher in your desired Kubernetes distribution
    <br />
    <a href="https://github.com/rancherlabs/tf-rancher-up/blob/main/README.md"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/rancherlabs/tf-rancher-up/blob/main/README.md">View Demo</a>
    ·
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
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project



This repository consists of reusable terraform [modules](./modules) that can be used to deploy Rancher which is a complete software stack for teams adopting containers. The various terraform modules here can be used to deploy Rancher on a kubernetes cluster provisioned in any of the infrastructure/cloud platforms (AWS/VMware/Azure/GCP/DigitalOcean). Provisioning can be customized using different kubernetes distributions(RKE/RKE2/K3S/EKS/AKS/GKE) and will be here by referred as [recipes](./recipes).  Upstream kubernetes(cluster used only for running Rancher) and Downstream kubernetes (cluster used for workloads) can be deployed using these terraform modules by stiching together various recipes.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

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

Git should be installed on the local or remote computer which is used for cloning the repository as mentioned above. Git comes installed by default on most Mac and Linux machines . Please refer the git installation guide 
https://github.com/git-guides/install-git if you need help.

Git clone can be performed only after setting up the required ssh keys. Please refer https://docs.github.com/en/authentication/connecting-to-github-with-ssh if you need help on this.


#### Terraform

Terraform should be installed on your local or remote computer where the repository is cloned.  Please refer https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli for installation instructions.


### Whats next

_Once you clone the repository please go to the desired [recipes](./recipes) path and start configuring required environmental variables for your platform. Please refer the README under [recipes](./recipes) for details._



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

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


#### Workflow for working with repos on GitHub:


- Clone or pull all changes
```bash
git pull --all
```
- Checkout the `main` branch if not already
```bash
git checkout main
```
- Create a feature branch to commit your changes
```bash
git checkout -b <branch name>
```
- Use concise but meaningful commit messages about what is changing
- Use `terraform fmt` to lint and format any changes that occured
```bash
terraform fmt -recursive .
```
- If the changes relate to the README, update the content for changed modules with `terraform-docs`:
```bash
terraform-docs markdown .
```
- Once ready, create a PR providing any testing and change details


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



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/rancherlabs/tf-rancher-up/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/othneildrew/Best-README-Template/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/othneildrew/Best-README-Template/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/othneildrew/Best-README-Template/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/othneildrew
[product-screenshot]: images/screenshot.png
[HCL]:68747470733a2f2f696d672e736869656c64732e696f2f7374617469632f76313f7374796c653d666f722d7468652d6261646765266d6573736167653d5465727261666f726d26636f6c6f723d374234324243266c6f676f3d5465727261666f726d266c6f676f436f6c6f723d464646464646266c6162656c3d
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 