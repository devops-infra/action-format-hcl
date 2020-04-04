# Format HCL files Action

Dockerized ([christophshyper/action-format-hcl](https://hub.docker.com/repository/docker/christophshyper/action-format-hcl)) GitHub Action automatically formatting all [HCL](https://github.com/hashicorp/hcl) files (.hcl, .tf, .tfvars) and committing fixed files back to the current branch.

Container is a stripped down image of my other creation - [ChristophShyper/docker-terragrunt](https://github.com/ChristophShyper/docker-terragrunt) - framework for managing Infrastructure-as-a-Code.

So it's main use will be everywhere where [Terraform](https://github.com/hashicorp/terraform) or [Terragrunt](https://github.com/gruntwork-io/terragrunt) is used.

Main action is using combination of my wrapper for [cytopia](https://github.com/cytopia)'s [docker-terragrunt-fmt](https://github.com/cytopia/docker-terragrunt-fmt/tree/3f8964bea0db043a05d4a8d622f94a07f109b5a7).

## Badge swag
[
![GitHub](https://img.shields.io/badge/github-ChristophShyper%2Faction--format--hcl-brightgreen.svg?style=flat-square&logo=github)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/christophshyper/action-format-hcl?color=brightgreen&label=Code%20size&style=flat-square&logo=github)
![GitHub last commit](https://img.shields.io/github/last-commit/christophshyper/action-format-hcl?color=brightgreen&label=Last%20commit&style=flat-square&logo=github)
![On each commit push](https://img.shields.io/github/workflow/status/christophshyper/action-format-hcl/On%20each%20commit%20push?color=brightgreen&label=Actions&logo=github&style=flat-square)
](https://github.com/christophshyper/action-format-hcl "shields.io")

[
![DockerHub](https://img.shields.io/badge/docker-christophshyper%2Faction--format--hcl-blue.svg?style=flat-square&logo=docker)
![Dockerfile size](https://img.shields.io/github/size/christophshyper/action-format-hcl/Dockerfile?label=Dockerfile&style=flat-square&logo=docker)
![Docker Pulls](https://img.shields.io/docker/pulls/christophshyper/action-format-hcl?color=blue&label=Pulls&logo=docker&style=flat-square)
![Docker version](https://img.shields.io/docker/v/christophshyper/action-format-hcl?color=blue&label=Version&logo=docker&style=flat-square)
](https://hub.docker.com/r/christophshyper/action-format-hcl "shields.io")

## Usage

Input Variable | Required | Default |Description
:--- | :---: | :---: | :---
fail_on_changes | No | `false` | Boolean value. Wheter action should fail if any mailformatted files are found.
github_token | If `push_changes` set to `true` | `""` | Personal Action Token for GitHub. Set to `${{ secrets.GITHUB_TOKEN }}`
push_changes | No | `false` | Boolean value. Whether changes should be pushed back to the current branch.

If `push_changes` is set to `true` then `fail_on_changes` will be treated as `false`.

## Examples

Action can fail if malformatted files will be found and no changes to repository will be done.
```yaml
name: Check HCL
on:
  push:
    branches:
      - "**"
jobs:
  format-hcl:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2
    - name: Fail on malformatted files
      uses: docker://christophshyper/action-format-hcl:latest
      with:
        fail_on_changes: true
```

Action can automatically format all HCL files and commit updated files back to the repository.
```yaml
name: Format HCL
on:
  push:
    branches:
      - "**"
jobs:
  format-hcl:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2
    - name: Format HCL
      uses: docker://christophshyper/action-format-hcl:latest
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        push_changes: true
```
