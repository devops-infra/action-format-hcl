# Instead of building from scratch pull my other docker image
FROM christophshyper/docker-terragrunt:latest as builder
RUN terraform --version

# Use a clean tiny image to store artifacts in
FROM alpine:3.11

# For http://label-schema.org/rc1/#build-time-labels
ARG VCS_REF=abcdef1
ARG BUILD_DATE=2020-04-01T00:00:00Z
LABEL \
    com.github.actions.author="Krzysztof Szyper <biotyk@mail.com>" \
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
	&& apk add --no-cache openssh \
	&& apk add --no-cache openssl \
    && mkdir -m 700 /root/.ssh \
    && touch -m 600 /root/.ssh/known_hosts \
    && ssh-keyscan -t rsa github.com > /root/.ssh/known_hosts \
    && rm -rf /var/cache/* \
    && rm -rf /root/.cache/*

WORKDIR /github/workspace
ENTRYPOINT format-hcl
