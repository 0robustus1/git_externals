#!/bin/bash

# Depends on gawk, for matching regular expression groups

# Accepts -l switch to decide how many branches/lines to print

limit=10

if [[ $1 == "-l" ]]; then
  limit=$2
fi

git reflog | gawk 'match($0, /checkout: moving from ([[:graph:]]+)/, matches) { if( !x[matches[1]]++ ) print matches[1] }' | head -n $limit
