FROM debian:stable-slim as builder

# Set latest versions as default for Terraform
ARG TF_VERSION=latest

# Install build dependencies on builder
RUN set -eux \
	&& DEBIAN_FRONTEND=noninteractive apt-get update -qq \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
		ca-certificates \
		curl \
		git \
		unzip \
	&& rm -rf /var/lib/apt/lists/* \
# Get Terraform
# TF_VERSION needs to point to explicit version, e.g. 0.12.24
	&& if [ "${TF_VERSION}" = "latest" ]; then \
		VERSION="$( curl -sS https://releases.hashicorp.com/terraform/ | cat \
			| grep -Eo '/[.0-9]+/' | grep -Eo '[.0-9]+' \
			| sort -V | tail -1 )"; \
	else \
		VERSION="${TF_VERSION}"; \
	fi \
	&& curl -sS -L -O \
		https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip \
	&& unzip terraform_${VERSION}_linux_amd64.zip \
	&& mv terraform /usr/bin/terraform \
	&& chmod +x /usr/bin/terraform \
# Get format-hcl script with dependencies
# Taken from: https://github.com/ChristophShyper/docker-terragrunt
	&& curl -sS -L \
        https://raw.githubusercontent.com/ChristophShyper/docker-terragrunt/master/fmt/format-hcl \
        -o /usr/bin/format-hcl \
    && chmod +x /usr/bin/format-hcl \
	&& curl -sS -L \
        https://raw.githubusercontent.com/ChristophShyper/docker-terragrunt/master/fmt/fmt.sh \
        -o /usr/bin/fmt.sh \
    && chmod +x /usr/bin/fmt.sh \
	&& curl -sS -L \
        https://raw.githubusercontent.com/ChristophShyper/docker-terragrunt/master/fmt/terragrunt-fmt.sh \
        -o /usr/bin/terragrunt-fmt.sh \
    && chmod +x /usr/bin/terragrunt-fmt.sh

# Use a clean tiny image to store artifacts in
FROM alpine:3.11

# For http://label-schema.org/rc1/#build-time-labels
ARG VCS_REF=abcdef1
ARG BUILD_DATE=2020-04-01T00:00:00Z
LABEL \
    com.github.actions.author="Format HCL files" \
    com.github.actions.color="white" \
    com.github.actions.description="Automatically format HCL files and commit fixed files back to current branch." \
    com.github.actions.icon="wind" \
    com.github.actions.name="Format HCL files and commit them" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.description="Docker image with GitHub action running format-hcl from https://github.com/ChristophShyper/docker-terragrunt." \
	org.label-schema.name="action-format-hcl" \
	org.label-schema.schema-version="1.0"	\
    org.label-schema.url="https://github.com/ChristophShyper/action-format-hcl" \
	org.label-schema.vcs-ref="${VCS_REF}" \
    org.label-schema.vcs-url="https://github.com/ChristophShyper/action-format-hcl" \
    org.label-schema.vendor="Krzysztof Szyper <biotyk@mail.com>" \
    org.label-schema.version="0.0" \
    maintainer="Krzysztof Szyper <biotyk@mail.com>" \
    repository="https://github.com/ChristophShyper/action-format-hcl" \
    alpine="3.11"

COPY --from=builder /usr/bin/terraform /usr/bin/format-hcl /usr/bin/fmt.sh /usr/bin/terragrunt-fmt.sh /usr/bin/

RUN set -eux \
    && chmod +x /usr/bin/format-hcl /usr/bin/fmt.sh /usr/bin/terragrunt-fmt.sh \
    && apk update --no-cache \
    && apk upgrade --no-cache \
	&& apk add --no-cache bash \
	&& apk add --no-cache git \
	&& apk add --no-cache make \
	&& apk add --no-cache openssh \
	&& apk add --no-cache openssl \
	&& apk add --no-cache zip \
    && mkdir -m 700 /root/.ssh \
    && touch -m 600 /root/.ssh/known_hosts \
    && ssh-keyscan -t rsa github.com > /root/.ssh/known_hosts \
    && rm -rf /var/cache/* \
    && rm -rf /root/.cache/*

WORKDIR /github/workspace
ENTRYPOINT format-hcl
