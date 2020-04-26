# GitHub Action for formating HCL files

**GitHub Action automatically formatting all [HCL](https://github.com/hashicorp/hcl) and [TF](https://www.terraform.io/docs/configuration/index.html) files (.hcl, .tf, .tfvars).**

Dockerized as [christophshyper/action-format-hcl](https://hub.docker.com/repository/docker/christophshyper/action-format-hcl). 

Features:
* Container is a stripped down image of my other creation - [ChristophShyper/docker-terragrunt](https://github.com/ChristophShyper/docker-terragrunt) - framework for managing Infrastructure-as-a-Code.
* Main use will be everywhere where [Terraform](https://github.com/hashicorp/terraform) or [Terragrunt](https://github.com/gruntwork-io/terragrunt) is used.
* Using combination of my wrapper for [cytopia](https://github.com/cytopia)'s [docker-terragrunt-fmt](https://github.com/cytopia/docker-terragrunt-fmt).


## Badge swag
[![Master branch](https://github.com/devops-infra/action-format-hcl/workflows/Master%20branch/badge.svg)](https://github.com/devops-infra/action-format-hcl/actions?query=workflow%3A%22Master+branch%22)
[![Other branches](https://github.com/devops-infra/action-format-hcl/workflows/Other%20branches/badge.svg)](https://github.com/devops-infra/action-format-hcl/actions?query=workflow%3A%22Other+branches%22)
<br>
[
![GitHub repo](https://img.shields.io/badge/GitHub-devops--infra%2Faction--format--hcl-blueviolet.svg?style=plastic&logo=github)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/devops-infra/action-format-hcl?color=blueviolet&label=Code%20size&style=plastic&logo=github)
![GitHub last commit](https://img.shields.io/github/last-commit/devops-infra/action-format-hcl?color=blueviolet&logo=github&style=plastic&label=Last%20commit)
![GitHub license](https://img.shields.io/github/license/devops-infra/action-format-hcl?color=blueviolet&logo=github&style=plastic&label=License)
](https://github.com/devops-infra/action-format-hcl "shields.io")
<br>
[
![DockerHub](https://img.shields.io/badge/DockerHub-christophshyper%2Faction--format--hcl-blue.svg?style=plastic&logo=docker)
![Docker version](https://img.shields.io/docker/v/christophshyper/action-format-hcl?color=blue&label=Version&logo=docker&style=plastic)
![Image size](https://img.shields.io/docker/image-size/christophshyper/action-format-hcl/latest?label=Image%20size&style=plastic&logo=docker)
![Docker Pulls](https://img.shields.io/docker/pulls/christophshyper/action-format-hcl?color=blue&label=Pulls&logo=docker&style=plastic)
](https://hub.docker.com/r/christophshyper/action-format-hcl "shields.io")


## Reference

```yaml
    - name: Fail on malformatted files
      uses: devops-infra/action-format-hcl@master
      with:
        fail_on_changes: true
```

Input Variable | Required | Default |Description
:--- | :---: | :---: | :---
fail_on_changes | No | `false` | Boolean value. Whether action should fail if any mailformatted files are found.


## Examples

Action can fail if malformatted files will be found.
```yaml
name: Check HCL
on:
  push
jobs:
  format-hcl:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2
    - name: Fail on malformatted files
      uses: devops-infra/action-format-hcl@master
      with:
        fail_on_changes: true
```

Action can automatically format all HCL files and commit updated files back to the repository using my other action [action-commit-push](https://github.com/devops-infra/action-commit-push).
```yaml
name: Format HCL
on:
  push
jobs:
  format-hcl:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2
    - name: Format HCL files
      uses: devops-infra/action-format-hcl@master
    - name: Commit changes to repo
      uses: devops-infra/action-commit-push@master
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        commit_prefix: "[AUTO-FORMAT-HCL]"
```
