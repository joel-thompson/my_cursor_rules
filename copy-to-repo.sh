#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load configuration
CONFIG_FILE="$SCRIPT_DIR/config.sh"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file not found at $CONFIG_FILE"
    echo "Please copy config.template.sh to config.sh and set your repository path."
    exit 1
fi

source "$CONFIG_FILE"

# Check if path is set
if [ -z "$pathToMyCursorRules" ]; then
    echo "Error: pathToMyCursorRules is not set in $CONFIG_FILE"
    exit 1
fi

# Check if rules repository exists
if [ ! -d "$pathToMyCursorRules" ]; then
    echo "Error: Rules repository not found at $pathToMyCursorRules"
    exit 1
fi

# Check if rules directory exists
rulesDir="${pathToMyCursorRules}rules"
if [ ! -d "$rulesDir" ]; then
    echo "Error: Rules directory not found at $rulesDir"
    exit 1
fi

# Array of accepted file extensions
acceptedExtensions=(".mdc")

# Function to list all local rule files
list_rules() {
    echo "Available local rule files:"
    for ext in "${acceptedExtensions[@]}"; do
        find ".cursor/rules" -type f -name "*$ext" -exec basename {} \; 2>/dev/null
    done
    exit 0
}

# Check for list parameter
if [ "$1" = "-list" ]; then
    if [ ! -d ".cursor/rules" ]; then
        echo "Error: No .cursor/rules directory found in current project"
        exit 1
    fi
    list_rules
fi

# Check if a rule file name was provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide a rule file name"
    echo "Usage: $0 <rule-file-name> or $0 -list"
    exit 1
fi

ruleFile="$1"
sourceDir=".cursor/rules"
sourceFile="${sourceDir}/${ruleFile}"
targetFile="${rulesDir}/${ruleFile}"
isOverwrite=false

# Check if .cursor/rules exists in current project
if [ ! -d "$sourceDir" ]; then
    echo "Error: No .cursor/rules directory found in current project"
    exit 1
fi

# Validate file extension
valid_extension=false
for ext in "${acceptedExtensions[@]}"; do
    if [[ "$ruleFile" == *"$ext" ]]; then
        valid_extension=true
        break
    fi
done

if [ "$valid_extension" = false ]; then
    echo "Error: Invalid file type. Accepted file types: ${acceptedExtensions[*]}"
    exit 1
fi

# Check if source file exists
if [ ! -f "$sourceFile" ]; then
    echo "Error: Rule file '$ruleFile' not found in $sourceDir"
    exit 1
fi

# Check if target file already exists in repo
if [ -f "$targetFile" ]; then
    read -p "File '$ruleFile' already exists in $rulesDir. Overwrite? (y/n): " confirm
    if [[ $confirm != [yY] ]]; then
        echo "Operation cancelled"
        exit 0
    fi
    isOverwrite=true
fi

# Copy the file
cp "$sourceFile" "$targetFile"
echo "Successfully copied '$ruleFile' to $rulesDir"

# Handle git operations
if [ "$isOverwrite" = true ]; then
    commitMessage="updated $ruleFile"
else
    commitMessage="added $ruleFile"
fi

read -p "Would you like to commit and push this change? (y/n): " gitConfirm
if [[ $gitConfirm == [yY] ]]; then
    # Save current directory and change to repository root
    currentDir=$(pwd)
    cd "$pathToMyCursorRules"
    
    # Add and commit the file
    git add "rules/$ruleFile"
    git commit -m "$commitMessage"
    
    # Push to current branch
    currentBranch=$(git rev-parse --abbrev-ref HEAD)
    git push origin "$currentBranch"
    
    # Return to original directory
    cd "$currentDir"
    echo "Changes committed and pushed to branch: $currentBranch"
fi
