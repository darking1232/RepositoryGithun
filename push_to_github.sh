#!/bin/bash

# Navigate to the repo directory (optional)
cd "$(dirname "$0")"

# Check for any changes
if git diff --quiet && git diff --cached --quiet; then
    echo "No changes to commit. Exiting."
    exit 0
fi

# Ask for commit message
read -p "Enter commit message: " msg

# Add and commit changes
git add .
git commit -m "$msg"
git push origin main
