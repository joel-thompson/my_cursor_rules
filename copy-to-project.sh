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

# Check if repository exists
if [ ! -d "$pathToMyCursorRules" ]; then
    echo "Error: Rules repository not found at $pathToMyCursorRules"
    exit 1
fi

# Default to cursor rules mode
windsurfMode=false
acceptedExtensions=(".mdc")
rulesDir="${pathToMyCursorRules}rules"
targetDir=".cursor/rules"

# Check for windsurf flag
if [ "$1" = "-w" ]; then
    windsurfMode=true
    acceptedExtensions=(".md")
    rulesDir="${pathToMyCursorRules}windsurf-rules"
    targetDir=".windsurf/rules"
    shift # Remove the -w flag from the arguments
fi

# Check if rules directory exists
if [ ! -d "$rulesDir" ]; then
    # Create windsurf-rules directory if it doesn't exist
    if [ "$windsurfMode" = true ]; then
        mkdir -p "$rulesDir"
        echo "Created windsurf rules directory at $rulesDir"
    else
        echo "Error: Rules directory not found at $rulesDir"
        exit 1
    fi
fi

# Function to list all rule files
list_rules() {
    echo "Available $([ "$windsurfMode" = true ] && echo "windsurf" || echo "cursor") rule files:"
    for ext in "${acceptedExtensions[@]}"; do
        find "$rulesDir" -type f -name "*$ext" -exec basename {} \; 2>/dev/null
    done
    exit 0
}

# Check for list parameter
if [ "$1" = "-list" ]; then
    list_rules
fi

# Check if a rule file name was provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide a rule file name"
    if [ "$windsurfMode" = true ]; then
        echo "Usage: copy-to-project.sh -w <rule-file-name> or copy-to-project.sh -w -list"
    else
        echo "Usage: copy-to-project.sh <rule-file-name> or copy-to-project.sh -list"
        echo "For windsurf rules, use the -w flag: copy-to-project.sh -w <rule-file-name>"
    fi
    exit 1
fi

ruleFile="$1"
sourceFile="${rulesDir}/${ruleFile}"
absoluteTargetDir="$(pwd)/$targetDir"
targetFile="${targetDir}/${ruleFile}"

# Validate file extension
valid_extension=false
for ext in "${acceptedExtensions[@]}"; do
    if [[ "$ruleFile" == *"$ext" ]]; then
        valid_extension=true
        break
    fi
done

if [ "$valid_extension" = false ]; then
    echo "Error: Invalid file type. Accepted file types for $([ "$windsurfMode" = true ] && echo "windsurf" || echo "cursor") rules: ${acceptedExtensions[*]}"
    exit 1
fi

# Check if source file exists
if [ ! -f "$sourceFile" ]; then
    echo "Error: Rule file '$ruleFile' not found in $rulesDir"
    exit 1
fi

# Check if rules directory exists and create if needed
if [ ! -d "$targetDir" ]; then
    read -p "Directory '$absoluteTargetDir' does not exist. Create it? (y/n): " confirm
    if [[ $confirm != [yY] ]]; then
        echo "Operation cancelled"
        exit 0
    fi
    mkdir -p "$targetDir"
fi

# Check if target file already exists
if [ -f "$targetFile" ]; then
    read -p "File '$ruleFile' already exists in $targetDir. Overwrite? (y/n): " confirm
    if [[ $confirm != [yY] ]]; then
        echo "Operation cancelled"
        exit 0
    fi
fi

# Copy the file
cp "$sourceFile" "$targetFile"
echo "Successfully copied '$ruleFile' to $targetDir"
