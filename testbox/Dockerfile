# docker pull solvaholic/testbox:latest

#
# Hi there future reader! @solvaholic put this Docker image together in an
# attempt to find a way 'round (spending time) installing yamllint and other
# packages every test run, from a GitHub Actions workflow.
#
# If you have any feedback at all, please share it!
# https://github.com/solvaholic/docker/issues/new/choose
#

# Use debian:9 because GitHub's workflow runners cache it.
FROM debian:9

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# NOTE: Removing a package from this list :point_down: will be a breaking
#       change. Before you head down that path, start versioning this image.

# Install prerequisite packages.
RUN apt update && apt install -y \
curl \
git \
nvi \
python3-pkg-resources \
shellcheck \
tmux \
yamllint

# TODO: Since that :point_up: effectively makes any project using this image
#       dependent on those packages, find a more reliable way to manage this.

CMD ["/bin/bash"]
