# Contributing Guideline

Thanks for contributing to the project!

Please review and follow the [Code of Conduct](https://github.com/rancherlabs/tf-rancher-up/blob/main/CODE_OF_CONDUCT.md).

Contributing to the project is not limited to writing the code or submitting the PR. We will also appreciate if you can file issues, provide feedback and suggest new features.

Of course, contributing the code is more than welcome! To keep things simple, if you're fixing a small issue, you can simply submit a PR and we will pick it up. However, if you're planning to submit a bigger PR to implement a new feature or fix a relatively complex bug, please open an issue that explains the change and the motivation for it. If you're addressing a bug, please explain how to reproduce it.

## Opening PRs and organizing commits

PRs should generally address only 1 issue at a time. If you need to fix two bugs, open two separate PRs. This will keep the scope of your pull requests smaller and allow them to be reviewed and merged more quickly.

When possible, fill out as much detail in the pull request as is reasonable. Explain main design considerations and behavior changes when adequate. Refer to the Jira case or the GitHub issue that you are addressing with the PR.

Generally, pull requests should consist of a single logical commit. However, if your PR is for a large feature, you may need a more logical breakdown of commits. This is fine as long as each commit is a single logical unit.

The other exception to this single-commit rule is if your PR includes a change to a vendored dependency or generated code. To make reviewing easier, these changes should be segregated into their own commit.

## Workflow to open a Pull Request

- Clone or pull all changes.

```sh
git clone  git@github.com:rancherlabs/tf-rancher-up.git

OR

git pull --all (if already cloned)
```
**This step internally does: git remote add origin https://github.com/rancherlabs/tf-rancher-up.git**

- Fork the project from [here](https://github.com/rancherlabs/tf-rancher-up/fork).

```sh
cd <cloned directory path>
git remote add mycopy <forked-url>
```
**Example: git remote add mycopy git@github.com:<your_github_id>/tf-rancher-up.git**

- Create your Feature Branch.

```sh
git checkout -b <feature-branch-name>
```
- Make changes in the code.

- Use `terraform fmt` to lint and format any changes that occurred.

```sh
terraform fmt -recursive .
```
- If the changes relate to the docs.md file, update the content for changed modules with `terraform-docs`.

**Please refer [here](https://github.com/terraform-docs/terraform-docs) for installation of `terraform-docs`**

```bash
 terraform-docs markdown .
```
- Commit your Changes.

```sh
git commit -m "concise and meaningful commit messages about what is changing"
```
- Push to the Branch.

```sh
 git push mycopy <feature-branch-name>
```
- Open a Pull Request(PR) providing any testing and change details from [here](https://github.com/rancherlabs/tf-rancher-up/pulls).

- After the PR is merged, delete the branch `<feature-branch-name>`.

- Dont push a branch to origin/main repository. Push only to forks.

### Reviewing and merging

Generally, pull requests need at least one approvals from maintainers to be merged.

Once a PR has the necessary approvals, it can be merged. Here’s how the merge should be handled:
- If the PR is a single logical commit, the merger should use the “Rebase and merge” option. This keeps the git commit history very clean and simple and eliminates noise from "merge commits."
- If the PR is more than one logical commit, the merger should use the “Create a merge commit” option.
- If the PR consists of more than one commit because the author added commits to address feedback, the commits should be squashed into a single commit (or more than one logical commit, if it is a big feature that needs more commits). This can be achieved in one of two ways:
  - The merger can use the “Squash and merge” option. If they do this, the merger is responsible for cleaning up the commit message according to the previously stated commit message guidance.
  - The pull request author, after getting the requisite approvals, can reorganize the commits as they see fit (using, for example, git rebase -i) and re-push.
