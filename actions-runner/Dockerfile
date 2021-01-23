FROM debian:buster-slim

# Set some environment variables:
ARG image_version
ARG _rel="2.276.1"
ENV _file="actions-runner-linux-x64-${_rel}.tar.gz"
ENV _url="https://github.com/actions/runner/releases/download/v${_rel}/${_file}"

LABEL name="solvaholic/actions-runner" \
      version="${image_version}" \
      maintainer="solvaholic on GitHub"

# Install prerequisite packages:
# hadolint ignore=DL3008,DL3009,DL3015
RUN apt-get update && apt-get install -y curl

# Create service user and working directory:
RUN useradd -c "" -m -p "" -s /bin/bash runner \
    && mkdir -p /home/runner/actions-runner \
    && chown -R runner:runner /home/runner
USER runner
WORKDIR /home/runner/actions-runner

# Download and extract application:
RUN echo "${_url}" \
    && curl -sLO "${_url}" \
    && tar xzf "${_file}" \
    && rm -v "${_file}"

# Install application dependencies:
USER root
RUN ./bin/installdependencies.sh
USER runner

# Visit your repo and add a self-hosted runner. Additional steps
# are provided on the web site. For example:
#   https://github.com/OWNER/REPO/settings/actions

# _token=YOURTOKENHERE
# _name=actions-runner
# _url=https://github.com/OWNER/REPO
# _tag=solvaholic/actions-runner:latest
#
# docker pull ${_tag}
# docker run -dt --name ${_name} ${_tag}
# docker exec ${_name} ./config.sh --url ${_url} --token ${_token}
# docker exec -d ${_name} ./run.sh

# Note: Do not use self-hosted runners on public repositories.

CMD ["/bin/bash"]
