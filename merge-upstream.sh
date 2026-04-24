#!/usr/bin/env bash

set -Eeuo pipefail
trap 'echo "⚠  Error ($0:$LINENO): $BASH_COMMAND" && return 3 2> /dev/null || exit 3' ERR

old_commit=$(git rev-parse upstream)

git fetch upstream

new_commit=$(git rev-parse upstream)

if [ "$old_commit" = "$new_commit" ]; then
  echo "No updates available"

  exit
fi

git switch update-metadata
git merge --no-edit upstream/main

git switch feat-msys2-support
git merge --no-edit upstream/main

git switch main
git reset --hard $(git rev-list --max-parents=0 HEAD)
git merge --no-edit upstream/main

# git merge --no-edit update-metadata feat-msys2-support
git merge --no-edit update-metadata
git merge --no-edit feat-msys2-support

git push --all --force
