# Instead of building from scratch pull my other docker image
FROM devopsinfra/docker-terragrunt:slim-tf-1.2.5-tg-0.38.6 as builder

# Use a clean tiny image to store artifacts in
FROM ubuntu:jammy-20221130

# Labels for http://label-schema.org/rc1/#build-time-labels
# And for https://github.com/opencontainers/image-spec/blob/master/annotations.md
# And for https://help.github.com/en/actions/building-actions/metadata-syntax-for-github-actions
ARG NAME="GitHub Action for formating HCL files"
ARG DESCRIPTION="GitHub Action automatically formatting all HCL and TF files."
ARG REPO_URL="https://github.com/devops-infra/action-format-hcl"
ARG AUTHOR="Krzysztof Szyper / ChristophShyper / biotyk@mail.com"
ARG HOMEPAGE="https://christophshyper.github.io/"
ARG BUILD_DATE=2020-04-01T00:00:00Z
ARG VCS_REF=abcdef1
ARG VERSION=v0.0
LABEL \
  com.github.actions.name="${NAME}" \
  com.github.actions.author="${AUTHOR}" \
  com.github.actions.description="${DESCRIPTION}" \
  com.github.actions.color="purple" \
  com.github.actions.icon="upload-cloud" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.name="${NAME}" \
  org.label-schema.description="${DESCRIPTION}" \
  org.label-schema.usage="README.md" \
  org.label-schema.url="${HOMEPAGE}" \
  org.label-schema.vcs-url="${REPO_URL}" \
  org.label-schema.vcs-ref="${VCS_REF}" \
  org.label-schema.vendor="${AUTHOR}" \
  org.label-schema.version="${VERSION}" \
  org.label-schema.schema-version="1.0"	\
  org.opencontainers.image.created="${BUILD_DATE}" \
  org.opencontainers.image.authors="${AUTHOR}" \
  org.opencontainers.image.url="${HOMEPAGE}" \
  org.opencontainers.image.documentation="${REPO_URL}/blob/master/README.md" \
  org.opencontainers.image.source="${REPO_URL}" \
  org.opencontainers.image.version="${VERSION}" \
  org.opencontainers.image.revision="${VCS_REF}" \
  org.opencontainers.image.vendor="${AUTHOR}" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.title="${NAME}" \
  org.opencontainers.image.description="${DESCRIPTION}" \
  maintainer="${AUTHOR}" \
  repository="${REPO_URL}"

# Copy all needed files
COPY --from=builder /usr/bin/terraform /usr/bin/format-hcl /usr/bin/fmt.sh /usr/bin/terragrunt-fmt.sh /usr/bin/
COPY entrypoint.sh /

# Install needed packages
# hadolint ignore=DL3008
RUN set -eux ;\
  apt-get update -y ;\
  apt-get install --no-install-recommends -y \
    git ;\
  chmod +x /entrypoint.sh /usr/bin/format-hcl /usr/bin/fmt.sh /usr/bin/terragrunt-fmt.sh ;\
  apt-get clean ;\
  rm -rf /var/lib/apt/lists/*

# Finish up
CMD ["terraform --version"]
WORKDIR /github/workspace
ENTRYPOINT ["/entrypoint.sh"]
