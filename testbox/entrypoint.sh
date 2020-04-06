#!/bin/sh -l

# Run script/test in the current checkout.

# Requirements:
#   - /github/workspace or /myrepo contains a clone of the repository to test
#   - If you pass GITHUB_TOKEN and GITHUB_USER, gh will use them.

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

echo "INFO: Found a Git repository in ${_myrepo}."

# If there's not already a gh config, and if GITHUB_USER and GITHUB_TOKEN are
# set, configure gh credentials.
_ghcfg=~/.config/gh/config.yml
if [ ! -f "${_ghcfg}" ] && [ -n "${GITHUB_USER}" ] && [ -n "${GITHUB_TOKEN}" ]
then
  echo "INFO: GITHUB_USER is set to '${GITHUB_USER}'."
  echo "INFO: GITHUB_TOKEN is set, too. Configuring gh."
  mkdir -p "$(dirname "$_ghcfg")"
  echo "github.com:" > "${_ghcfg}"
  echo "- user: ${GITHUB_USER}" >> "${_ghcfg}"
  echo "  oauth_token: ${GITHUB_TOKEN}" >> "${_ghcfg}"
fi

# If $_myrepo/script/test is not executable, fail.
[ -x "${_myrepo}/script/test" ] || exit

echo "INFO: Found script/test. Running it."

"${_myrepo}/script/test" || exit
