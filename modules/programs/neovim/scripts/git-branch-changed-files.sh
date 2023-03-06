#!/usr/env bash

CURRENT_BRANCH=`git branch --show-current`
BASE_BRANCH=$1
if [[ $BASE_BRANCH == "" ]] then
    BASE_BRANCH=`[ -f "$(git rev-parse --show-toplevel)/.git/refs/heads/master" ] && echo master || echo main`
fi
BASE_COMMIT=`git merge-base $BASE_BRANCH $CURRENT_BRANCH`

git diff --name-only --diff-filter=ACMR --relative $BASE_COMMIT

