ARG AWS_CLI_VERSION=2.1.38
FROM amazon/aws-cli:${AWS_CLI_VERSION}

## Repeating the ARG to add it into the scope of this image
ARG AWS_CLI_VERSION=2.1.38

## bash need to be installed for this instruction to work as expected
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

### Build requirements
RUN yum install -y \
    curl-* \
    git-* \
    make-* \
    unzip-* \
    which-* \
  && yum clean all

### Install JQ to allow JSON command line management
ARG JQ_VERSION=1.5
RUN curl --silent --show-error --location --output /usr/local/bin/jq \
    "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" \
  && chmod a+x /usr/local/bin/jq \
  && jq --version | grep -q "${JQ_VERSION}"

ENV USER=infra
ENV HOME=/home/"${USER}"

RUN adduser -D -u 1000 "${USER}" \
  && chown -R "${USER}" /home/"${USER}" \
  && chmod -R 750 /home/"${USER}"

USER "${USER}"

LABEL io.jenkins-infra.tools="aws-cli,jq"
LABEL io.jenkins-infra.tools.aws-cli.version="${AWS_CLI_VERSION}"
LABEL io.jenkins-infra.tools.aws-cli.version="${JQ_VERSION}"

WORKDIR /app

CMD ["/bin/bash"]
