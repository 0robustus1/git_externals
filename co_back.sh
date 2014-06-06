#!/bin/bash

branch=$(git reflog | grep -oP "(?<=checkout: moving from )[^\s]+" | head -n 1)
git checkout $branch
