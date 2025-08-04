#!/bin/bash

# Navigate to the repo directory (optional)
cd "$(dirname "$0")"

# Function to show files that will be committed
show_files_to_commit() {
    echo "=== Files that will be committed ==="
    echo ""
    
    # Show staged files (already added)
    if ! git diff --cached --quiet; then
        echo "?? Staged files (already added):"
        git diff --cached --name-only | sed 's/^/  - /'
        echo ""
    fi
    
    # Show unstaged files (not yet added)
    if ! git diff --quiet; then
        echo "?? Unstaged files (not yet added):"
        git diff --name-only | sed 's/^/  - /'
        echo ""
    fi
    
    # Show untracked files
    untracked=$(git ls-files --others --exclude-standard)
    if [ -n "$untracked" ]; then
        echo "?? Untracked files:"
        echo "$untracked" | sed 's/^/  - /'
        echo ""
    fi
    
    # Show total count
    staged_count=$(git diff --cached --name-only 2>/dev/null | wc -l)
    unstaged_count=$(git diff --name-only 2>/dev/null | wc -l)
    untracked_count=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)
    
    echo "?? Summary:"
    echo "  - Staged files: $staged_count"
    echo "  - Unstaged files: $unstaged_count"
    echo "  - Untracked files: $untracked_count"
    echo ""
}

# Check for any changes
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "No changes to commit. Exiting."
    exit 0
fi

# Show files that will be committed
show_files_to_commit

# Ask for commit message
read -p "Enter commit message: " msg

# Add and commit changes
echo "Adding all changes..."
git add .

# Show final list of files being committed
echo ""
echo "=== Final files being committed ==="
git diff --cached --name-only | sed 's/^/  - /'
echo ""

# Commit and push
echo "Committing changes..."
git commit -m "$msg"
git push origin main

echo "? Commit and push completed successfully!"
