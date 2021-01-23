#!/bin/sh -l

# Run script/test in the current checkout.

# Requirements:
#   - /github/workspace or /myrepo contains a clone of the repository to test
#   - If GITHUB_TOKEN and GITHUB_USER are set, gh will use them.

# If /github/workspace is not a Git repository, try /myrepo.
echo "INFO: Checking for a repository in /github/workspace, or /myrepo."
if git rev-parse --resolve-git-dir /github/workspace/.git 2>/dev/null; then
  _myrepo=/github/workspace
elif git rev-parse --resolve-git-dir /myrepo/.git 2>/dev/null; then
  _myrepo=/myrepo
else
  echo "      ... None found."
  _myrepo=""
fi

[ -n "${_myrepo}" ] && echo "INFO: Found a Git repository in ${_myrepo}."

/bin/bash
