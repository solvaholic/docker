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

# Build donor image, to copy some things over rather than install in-place.
FROM debian:buster AS donor
RUN apt update && apt install -y locales

# Build and set locale; Copy /usr/lib/locale/en_US.UTF-8 to desired target.
RUN cp /usr/share/i18n/charmaps/UTF-8.gz /tmp && \
    cd /tmp && rm -rf /tmp/UTF-8 && \
    gzip -d UTF-8.gz && \
    localedef -f /tmp/UTF-8 -i /usr/share/i18n/locales/en_US \
    /usr/lib/locale/en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# Build testbox image.
FROM debian:buster AS testbox

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

# Build and set locale, so text encoding and decoding can work reliably.
# Copy these from the donor image:
#   /usr/lib/locale/en_US.UTF-8
RUN mkdir -p /usr/lib/locale/en_US.UTF-8
COPY --from=donor /usr/lib/locale/en_US.UTF-8 /usr/lib/locale/en_US.UTF-8/
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Add helpful scripts.
ADD vm_files /
