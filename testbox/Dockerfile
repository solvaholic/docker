#
# Usage examples:
#
#   # Get a disposable shell.
#   docker run -t --rm solvaholic/testbox:latest /bin/bash
#
#   # Learn more about this image.
#   docker run -t --rm solvaholic/testbox:latest /help
#

#
# If you have any feedback at all, please share it!
# https://github.com/solvaholic/docker/issues/new/choose
#

# Use debian:buster, to get OpenSSH 7.9p1.

# Build donor image, to copy some things over rather than install in-place.
FROM debian:buster AS donor

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install --no-install-recommends -y locales && \
    rm -rf /var/lib/apt/lists/*

# Build and set locale
# (Generate /usr/lib/locale/en_US.UTF-8 for testbox target)
WORKDIR /tmp
RUN cp /usr/share/i18n/charmaps/UTF-8.gz /tmp && \
    rm -rf /tmp/UTF-8 && \
    gzip -d UTF-8.gz && \
    localedef -f /tmp/UTF-8 -i /usr/share/i18n/locales/en_US \
    /usr/lib/locale/en_US.UTF-8

# Build testbox image
FROM debian:buster AS testbox
ARG image_version
ENV GH_VERSION=1.4.0

LABEL name="solvaholic/testbox" \
      version="${image_version}" \
      maintainer="solvaholic on GitHub" \
      org.opencontainers.image.source="https://github.com/solvaholic/docker/blob/${image_version}/testbox/Dockerfile"

ENTRYPOINT ["/bin/bash", "-c", "--"]
CMD ["/entrypoint.sh"]

# Install prerequisite packages
# hadolint ignore=DL3008,DL3009
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        curl \
        git \
        man \
        ncat \
        nvi \
        shellcheck \
        sudo \
        tmux

# Install gh
ADD https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.deb /
RUN dpkg -i ./gh_*.deb && rm -f ./gh_*.deb

# Add a couple non-root user accounts
RUN useradd -c "" -m -p "" -s /bin/bash user1; \
    useradd -c "" -m -p "" -s /bin/bash user2; \
    useradd -c "" -m -p "" -s /bin/bash user3;

# Set locale, so text encoding and decoding can work reliably
RUN mkdir -p /usr/lib/locale/en_US.UTF-8
COPY --from=donor /usr/lib/locale/en_US.UTF-8 /usr/lib/locale/en_US.UTF-8/
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Add helpful scripts
COPY vm_files /

USER user1
