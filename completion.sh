#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load configuration
CONFIG_FILE="$SCRIPT_DIR/config.sh"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

_copy_to_project_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="-list"

    # If we have a valid repository path
    if [ -n "$pathToMyCursorRules" ] && [ -d "${pathToMyCursorRules}rules" ]; then
        # Add all .mdc files from the repository to the options
        while IFS= read -r -d '' file; do
            opts="$opts $(basename "$file")"
        done < <(find "${pathToMyCursorRules}rules" -type f -name "*.mdc" -print0)
    fi

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

_copy_to_repo_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="-list"

    # If .cursor/rules exists in current directory
    if [ -d ".cursor/rules" ]; then
        # Add all .mdc files from the current project to the options
        while IFS= read -r -d '' file; do
            opts="$opts $(basename "$file")"
        done < <(find ".cursor/rules" -type f -name "*.mdc" -print0)
    fi

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

# Register the completion functions
complete -F _copy_to_project_completion copy-to-project.sh
complete -F _copy_to_project_completion crget
complete -F _copy_to_repo_completion copy-to-repo.sh
complete -F _copy_to_repo_completion crput 