#!/usr/bin/env bash
set -euo pipefail

# Check for required dependencies
command -v git >/dev/null 2>&1 || { echo "ERROR: git not found" >&2; exit 1; }

# Ensure we're in a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "ERROR: Not in a git repository" >&2
    exit 1
fi

CURRENT_BRANCH=$(git branch --show-current)
BASE_BRANCH=${1:-}
if [[ -z "$BASE_BRANCH" ]]; then
    BASE_BRANCH=$([ -f "$(git rev-parse --show-toplevel)/.git/refs/heads/master" ] && echo master || echo main)
fi

# Verify base branch exists
if ! git rev-parse --verify "$BASE_BRANCH" >/dev/null 2>&1; then
    echo "ERROR: Base branch '$BASE_BRANCH' does not exist" >&2
    exit 1
fi

BASE_COMMIT=$(git merge-base "$BASE_BRANCH" "$CURRENT_BRANCH")

git diff --name-only --diff-filter=ACMR --relative "$BASE_COMMIT"

