# docker pull solvaholic/testbox:latest

# Use debian:9 because GitHub's workflow runners cache it.
FROM debian:9

# Install prerequisite packages.
RUN apt update && apt install -y \
curl \
git \
nvi \
python3-pkg-resources \
shellcheck \
tmux \
yamllint

CMD ["/bin/bash"]
