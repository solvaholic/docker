#
# Usage example:
# docker run -t --rm -v $(realpath .):/myrepo:ro solvaholic/testbox:latest
#

#
# Hi there future reader! @solvaholic put this Docker image together in an
# attempt to find a way 'round (spending time) installing yamllint and other
# packages every test run, on a GitHub Actions workflow runner.
#
# If you have any feedback at all, please share it!
# https://github.com/solvaholic/docker/issues/new/choose
#

# Use debian:9 because GitHub's workflow runners cache it.
FROM debian:9

# Set ENTRYPOINT and CMD to run /entrypoint.sh by default.
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/bash", "-c"]

# NOTE: Removing a package from this list :point_down: will be a breaking
#       change. Before you head down that path, start versioning this image.

# Install prerequisite packages.
RUN apt update && apt install -y \
curl \
git \
locales \
nvi \
python3-pkg-resources \
shellcheck \
tmux \
yamllint

# TODO: Since that :point_up: effectively makes any project using this image
#       dependent on those packages, find a more reliable way to manage this.

# Build and set locale, so text encoding and decoding can work reliably.
RUN echo en_US.UTF-8\ UTF-8 > /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

CMD ["/entrypoint.sh"]
