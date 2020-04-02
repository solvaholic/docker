#!/bin/sh -l

# Run script/test in the current checkout.

# Requirements:
#   - /github/workspace or /myrepo contains a clone of the repository to test

# If /github/workspace is not a Git repository, try /myrepo. If that's not,
# either, then fail.
echo "INFO: Checking for a repository in /github/workspace, or /myrepo."
if git rev-parse --resolve-git-dir /github/workspace/.git >/dev/null; then
  _myrepo=/github/workspace
elif git rev-parse --resolve-git-dir /myrepo/.git >/dev/null; then
  _myrepo=/myrepo
else
  exit
fi

echo "INFO: Found a repository in ${_myrepo}."

# If $_myrepo/script/test is not executable, fail.
[ -x "${_myrepo}/script/test" ] || exit

echo "INFO: Found script/test. Running it."

"${_myrepo}/script/test"
