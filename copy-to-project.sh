#!/bin/bash

# Path to the my_cursor_rules repository
pathToMyCursorRules="/Users/Joel/src/my_cursor_rules/"

# Array of accepted file extensions
acceptedExtensions=(".mdc")

# Function to list all rule files
list_rules() {
    echo "Available rule files:"
    for ext in "${acceptedExtensions[@]}"; do
        find "$pathToMyCursorRules" -type f -name "*$ext" -exec basename {} \;
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
    echo "Usage: $0 <rule-file-name> or $0 -list"
    exit 1
fi

ruleFile="$1"
sourceFile="${pathToMyCursorRules}${ruleFile}"
targetDir=".cursor/rules"
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
    echo "Error: Invalid file type. Accepted file types: ${acceptedExtensions[*]}"
    exit 1
fi

# Check if source file exists
if [ ! -f "$sourceFile" ]; then
    echo "Error: Rule file '$ruleFile' not found in $pathToMyCursorRules"
    exit 1
fi

# Check if .cursor/rules directory exists and create if needed
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
