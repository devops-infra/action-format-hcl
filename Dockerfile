FROM hashicorp/terraform:1.15 AS terraform
# Instead of building from scratch pull my other docker image
FROM devopsinfra/docker-terragrunt:slim-latest AS builder

# Use a clean tiny image to store artifacts in
FROM alpine:3.23.4

# Copy all needed files
COPY --from=terraform /usr/bin/terraform /usr/bin/terraform
COPY --from=builder /usr/bin/format-hcl /usr/bin/fmt.sh /usr/bin/terragrunt-fmt.sh /usr/bin/
COPY entrypoint.sh /
COPY alpine-packages.txt /tmp/alpine-packages.txt

# Install needed packages
SHELL ["/bin/sh", "-euxo", "pipefail", "-c"]
# hadolint ignore=DL3018
RUN set -eux; \
  xargs -r apk add --no-cache < /tmp/alpine-packages.txt; \
  chmod +x /entrypoint.sh /usr/bin/terraform /usr/bin/format-hcl /usr/bin/fmt.sh /usr/bin/terragrunt-fmt.sh; \
  terraform version; \
  rm -rf /var/cache/*; \
  rm -rf /root/.cache/*; \
  rm -rf /tmp/*

# Finish up
CMD ["terraform", "--version"]
WORKDIR /github/workspace
ENTRYPOINT ["/entrypoint.sh"]
