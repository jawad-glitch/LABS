#!/bin/bash
set -u

case "${1:-status}" in
  status)
    git status --short
    git branch --show-current
    git log --oneline -5
    ;;
  sync)
    git fetch upstream
    DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/upstream/HEAD 2>/dev/null | sed 's#^refs/remotes/upstream/##')
    if [ -z "$DEFAULT_BRANCH" ]; then
      echo "Could not determine upstream default branch."
      exit 1
    fi
    git switch "$DEFAULT_BRANCH"
    git merge --ff-only "upstream/$DEFAULT_BRANCH"
    git push origin "$DEFAULT_BRANCH"
    ;;
  rebase)
    BRANCH="${2:-}"
    if [ -z "$BRANCH" ]; then
      echo "Usage: ./pr_maintenance.sh rebase BRANCH_NAME"
      exit 2
    fi
    git fetch upstream
    DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/upstream/HEAD 2>/dev/null | sed 's#^refs/remotes/upstream/##')
    if [ -z "$DEFAULT_BRANCH" ]; then
      echo "Could not determine upstream default branch."
      exit 1
    fi
    git switch "$BRANCH"
    git rebase "upstream/$DEFAULT_BRANCH"
    echo "Review the rebase, then push with --force-with-lease if appropriate."
    ;;
  *)
    echo "Usage: ./pr_maintenance.sh [status|sync|rebase BRANCH_NAME]"
    exit 2
    ;;
esac
