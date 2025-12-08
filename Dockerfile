# Instead of building from scratch pull my other docker image
FROM devopsinfra/docker-terragrunt:slim-latest AS builder

# Use a clean tiny image to store artifacts in
FROM ubuntu:questing-20251029

# Disable interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Copy all needed files
COPY --from=builder /usr/bin/terraform /usr/bin/format-hcl /usr/bin/fmt.sh /usr/bin/terragrunt-fmt.sh /usr/bin/
COPY entrypoint.sh /

# Install needed packages
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
# hadolint ignore=DL3008
RUN set -eux ;\
  apt-get update -y ;\
  chmod +x /entrypoint.sh /usr/bin/format-hcl /usr/bin/fmt.sh /usr/bin/terragrunt-fmt.sh ;\
  apt-get clean ;\
  rm -rf /var/lib/apt/lists/*

# Finish up
CMD ["terraform --version"]
WORKDIR /github/workspace
ENTRYPOINT ["/entrypoint.sh"]
