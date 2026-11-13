#!/bin/bash
echo "After a real pull request is merged, typical cleanup is:"
echo "git checkout <default-branch>"
echo "git pull upstream <default-branch>"
echo "git branch -d improve-documentation"
echo "Delete the remote feature branch only when appropriate."
