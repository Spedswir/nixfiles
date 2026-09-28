#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    printf 'Usage: %s REPOSITORY UPDATE_NAME\n' "$0" >&2
    exit 2
fi

repo=$1
update_name=$2

cd -- "$repo"
git rev-parse --show-toplevel > /dev/null

# Stop if authentication fails or the branches cannot fast-forward.
git pull --ff-only

git add -A
if git diff --cached --quiet; then
    printf 'No new changes to commit: %s\n' "$update_name"
else
    diff_status=$?
    if [[ $diff_status -ne 1 ]]; then
        exit "$diff_status"
    fi
    git commit -m "Script update $update_name on $(date '+%Y-%m-%d %T')"
fi

# Push even when there were no new changes, to send any earlier local commits.
git push

printf 'Git Update Complete: %s\n' "$update_name"
