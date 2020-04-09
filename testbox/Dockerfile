#
# Usage examples:
#
#   # Run ./script/test on the current checkout.
#   docker run -t --rm -v $(realpath .):/myrepo:ro solvaholic/testbox:latest
#
#   # Get a disposable shell.
#   docker run -t --rm solvaholic/testbox:latest /bin/bash
#
#   # Learn more about this image.
#   docker run -t --rm solvaholic/testbox:latest /help
#

#
# Hi there future reader! @solvaholic put this Docker image together in an
# attempt to find a way 'round (spending time) installing yamllint and other
# packages every test run, on a GitHub Actions workflow runner.
#
# If you have any feedback at all, please share it!
# https://github.com/solvaholic/docker/issues/new/choose
#

# Use debian:buster, to get OpenSSH 7.9p1.
FROM debian:buster

# Set ENTRYPOINT and CMD to run /entrypoint.sh by default.
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/bash", "-c", "--"]
CMD ["/entrypoint.sh"]

# NOTE: Removing a package from this list :point_down: will be a breaking
#       change. Before you head down that path, start versioning this image.

# Install prerequisite packages.
RUN apt update && apt install -y \
curl \
git \
locales \
man \
nvi \
python3-pkg-resources \
shellcheck \
sudo \
tmux \
yamllint

# TODO: Since that :point_up: effectively makes any project using this image
#       dependent on those packages, find a more reliable way to manage this.

ADD https://github.com/cli/cli/releases/download/v0.6.4/gh_0.6.4_linux_amd64.deb /
RUN dpkg -i ./gh_*.deb

# Configure Git client for root user.
RUN git config --global user.name root; \
    git config --global user.email root@localhost

# Add a couple non-root user accounts.
RUN useradd -c "" -m -p "" -s /bin/bash user1; \
    useradd -c "" -m -p "" -s /bin/bash user2; \
    useradd -c "" -m -p "" -s /bin/bash user3;

# Add helpful scripts.
ADD vm_files /

# Build and set locale, so text encoding and decoding can work reliably.
RUN echo en_US.UTF-8\ UTF-8 > /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
