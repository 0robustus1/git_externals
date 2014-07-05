#!/bin/bash

# Depends on awk. But any distribution will do, and as awk is usually included
# on every system the dependency should be satisfied.

# Needs a basebranch to ignore commits from (to isolate the commits which are
# solely part of a given branch).
basebranch=$1

if [[ -z $basebranch ]]; then
  echo "Please provide a basebranch for calculation, e.g. master or staging."
  exit 1
fi

# Currently compares to the local user-settings. I'm not sure if this is
# automatically mailmap aware.
author=`git config user.name`
author+=" <$(git config user.email)>"

for branch in `git branch | awk '{ print ($2 ? $2 : $1) }'`; do
  commit_count=`git rev-list --author="$author" $basebranch..$branch | wc -l`

  if [[ $commit_count -gt 0 ]]; then
    echo "$branch"
  fi
done
