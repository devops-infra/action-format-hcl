# GitHub Action for formating HCL files

**GitHub Action automatically formatting all [HCL](https://github.com/hashicorp/hcl) and [TF](https://www.terraform.io/docs/configuration/index.html) files (.hcl, .tf, .tfvars).**

Dockerized as [devopsinfra/action-format-hcl](https://hub.docker.com/repository/docker/devopsinfra/action-format-hcl). 

Features:
* Container is a stripped down image of my other creation - [devopsinfra/docker-terragrunt](https://github.com/devopsinfra/docker-terragrunt) - framework for managing Infrastructure-as-a-Code.
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
![DockerHub](https://img.shields.io/badge/DockerHub-devopsinfra%2Faction--format--hcl-blue.svg?style=plastic&logo=docker)
![Docker version](https://img.shields.io/docker/v/devopsinfra/action-format-hcl?color=blue&label=Version&logo=docker&style=plastic)
![Image size](https://img.shields.io/docker/image-size/devopsinfra/action-format-hcl/latest?label=Image%20size&style=plastic&logo=docker)
![Docker Pulls](https://img.shields.io/docker/pulls/devopsinfra/action-format-hcl?color=blue&label=Pulls&logo=docker&style=plastic)
](https://hub.docker.com/r/devopsinfra/action-format-hcl "shields.io")


## Reference

```yaml
    - name: Fail on malformatted files
      uses: devops-infra/action-format-hcl@v0.2
      with:
        list: false
        write: true
        ignore: "config"
        diff: false
        check: false
        recursive: true
        dir: "modules"
```

Input Variable | Required | Default |Description
:--- | :---: | :---: | :---
list | No | `false` | List files containing formatting inconsistencies.
write | No | `true` | Overwrite input files. Disabled if using check.
ignore | No | `""` | Comma separated list of paths to ignore. Only for .hcl files.
diff | No | `false` | Display diffs of formatting changes.
check | No | `false` | Check if files are malformatted.
recursive | No | `true` | Also process files in subdirectories.
dir | No | `""` | Path to be checked. Current dir as default.


## Examples

Action can fail if malformed files will be found.
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
      uses: devops-infra/action-format-hcl@v0.2
      with:
        check: true
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
      uses: devops-infra/action-format-hcl@v0.2
    - name: Commit changes to repo
      uses: devops-infra/action-commit-push@master
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        commit_prefix: "[AUTO-FORMAT-HCL]"
```
