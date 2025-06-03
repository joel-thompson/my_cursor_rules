#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load configuration
CONFIG_FILE="$SCRIPT_DIR/config.sh"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

_copy_to_project_completion() {
    local cur prev opts windsurfMode
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="-list -w"
    windsurfMode=false

    # Check if -w flag was used anywhere in the command
    for ((i=1; i < COMP_CWORD; i++)); do
        if [[ "${COMP_WORDS[i]}" == "-w" ]]; then
            windsurfMode=true
            break
        fi
    done

    # If we have a valid repository path
    if [ -n "$pathToMyCursorRules" ]; then
        if [ "$windsurfMode" = true ]; then
            # Add windsurf rules path and extension
            ruleDir="${pathToMyCursorRules}windsurf-rules"
            extension="*.md"
        else
            # Default to cursor rules
            ruleDir="${pathToMyCursorRules}rules"
            extension="*.mdc"
        fi

        # Check if the directory exists
        if [ -d "$ruleDir" ]; then
            # Add all rule files from the repository to the options
            while IFS= read -r -d '' file; do
                opts="$opts $(basename "$file")"
            done < <(find "$ruleDir" -type f -name "$extension" -print0 2>/dev/null)
        fi
    fi
    
    # If the previous word is -w, provide options suitable after -w flag
    if [[ "$prev" == "-w" ]]; then
        opts="-list"
        if [ -d "${pathToMyCursorRules}windsurf-rules" ]; then
            while IFS= read -r -d '' file; do
                opts="$opts $(basename "$file")"
            done < <(find "${pathToMyCursorRules}windsurf-rules" -type f -name "*.md" -print0 2>/dev/null)
        fi
    fi

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

_copy_to_repo_completion() {
    local cur prev opts windsurfMode
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="-list -w"
    windsurfMode=false

    # Check if -w flag was used anywhere in the command
    for ((i=1; i < COMP_CWORD; i++)); do
        if [[ "${COMP_WORDS[i]}" == "-w" ]]; then
            windsurfMode=true
            break
        fi
    done

    if [ "$windsurfMode" = true ]; then
        # Windsurf rules
        ruleDir=".windsurf/rules"
        extension="*.md"
    else
        # Default to cursor rules
        ruleDir=".cursor/rules"
        extension="*.mdc"
    fi

    # If the rules directory exists in current directory
    if [ -d "$ruleDir" ]; then
        # Add all rule files from the current project to the options
        while IFS= read -r -d '' file; do
            opts="$opts $(basename "$file")"
        done < <(find "$ruleDir" -type f -name "$extension" -print0 2>/dev/null)
    fi
    
    # If the previous word is -w, provide options suitable after -w flag
    if [[ "$prev" == "-w" ]]; then
        opts="-list"
        if [ -d ".windsurf/rules" ]; then
            while IFS= read -r -d '' file; do
                opts="$opts $(basename "$file")"
            done < <(find ".windsurf/rules" -type f -name "*.md" -print0 2>/dev/null)
        fi
    fi

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

# Register the completion functions
complete -F _copy_to_project_completion copy-to-project.sh
complete -F _copy_to_project_completion crget
complete -F _copy_to_repo_completion copy-to-repo.sh
complete -F _copy_to_repo_completion crput