#!/bin/bash

function pull_changes {
  if [ -d .git ]; then
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    git pull origin "$current_branch"
  fi
}

# Register the function to run every time I cd into a directory
cd() {
  builtin cd "$@" && pull_changes
}
