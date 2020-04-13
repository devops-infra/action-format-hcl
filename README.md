# Format HCL files Action

GitHub Action automatically formatting all [HCL](https://github.com/hashicorp/hcl) and [TF](https://www.terraform.io/docs/configuration/index.html) files (.hcl, .tf, .tfvars).

Dockerized as [christophshyper/action-format-hcl](https://hub.docker.com/repository/docker/christophshyper/action-format-hcl). 

Container is a stripped down image of my other creation - [ChristophShyper/docker-terragrunt](https://github.com/ChristophShyper/docker-terragrunt) - framework for managing Infrastructure-as-a-Code.

So it's main use will be everywhere where [Terraform](https://github.com/hashicorp/terraform) or [Terragrunt](https://github.com/gruntwork-io/terragrunt) is used.

Main action is using combination of my wrapper for [cytopia](https://github.com/cytopia)'s [docker-terragrunt-fmt](https://github.com/cytopia/docker-terragrunt-fmt).


## Badge swag
[
![GitHub](https://img.shields.io/badge/github-ChristophShyper%2Faction--format--hcl-brightgreen.svg?style=flat-square&logo=github)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/christophshyper/action-format-hcl?color=brightgreen&label=Code%20size&style=flat-square&logo=github)
![GitHub last commit](https://img.shields.io/github/last-commit/christophshyper/action-format-hcl?color=brightgreen&label=Last%20commit&style=flat-square&logo=github)
](https://github.com/christophshyper/action-format-hcl "shields.io")
[![Push to master](https://img.shields.io/github/workflow/status/christophshyper/action-format-hcl/Push%20to%20master?color=brightgreen&label=Master%20branch&logo=github&style=flat-square)
](https://github.com/ChristophShyper/action-format-hcl/actions?query=workflow%3A%22Push+to+master%22)
[![Push to other](https://img.shields.io/github/workflow/status/christophshyper/action-format-hcl/Push%20to%20other?color=brightgreen&label=Pull%20requests&logo=github&style=flat-square)
](https://github.com/ChristophShyper/action-format-hcl/actions?query=workflow%3A%22Push+to+other%22)
<br>
[
![DockerHub](https://img.shields.io/badge/docker-christophshyper%2Faction--format--hcl-blue.svg?style=flat-square&logo=docker)
![Dockerfile size](https://img.shields.io/github/size/christophshyper/action-format-hcl/Dockerfile?label=Dockerfile%20size&style=flat-square&logo=docker)
![Image size](https://img.shields.io/docker/image-size/christophshyper/action-format-hcl/latest?label=Image%20size&style=flat-square&logo=docker)
![Docker Pulls](https://img.shields.io/docker/pulls/christophshyper/action-format-hcl?color=blue&label=Pulls&logo=docker&style=flat-square)
![Docker version](https://img.shields.io/docker/v/christophshyper/action-format-hcl?color=blue&label=Version&logo=docker&style=flat-square)
](https://hub.docker.com/r/christophshyper/action-format-hcl "shields.io")


## Reference

```yaml
    - name: Fail on malformatted files
      uses: ChristophShyper/action-format-hcl@master
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
      uses: docker://christophshyper/action-format-hcl:latest
      with:
        fail_on_changes: true
```

Action can automatically format all HCL files and commit updated files back to the repository using my other action [action-commit-push](https://github.com/christophshyper/action-commit-push).
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
      uses: docker://christophshyper/action-format-hcl:latest
    - name: Commit changes to repo
      uses: docker://christophshyper/action-commit-push:latest
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        commit_prefix: "[AUTO-FORMAT-HCL]"
```
