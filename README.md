# Terraform modules for bringing up Rancher

This repository consists of reusable terraform [modules](./modules), and they are stitched together to form various [recipes](./recipes). 

---

### Contributing

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
