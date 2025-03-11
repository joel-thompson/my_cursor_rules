# My Cursor Rules

A repository to manage and share Cursor IDE rules across different projects.

## Setup

1. Clone this repository:
```bash
git clone https://github.com/joel-thompson/my_cursor_rules.git
cd my_cursor_rules
```

2. Create your local configuration:
```bash
cp config.template.sh config.sh
```

3. Edit `config.sh` and set your repository path:
```bash
export pathToMyCursorRules="/path/to/your/my_cursor_rules/"  # Update this path
```

4. Make the scripts executable:
```bash
chmod +x copy-to-project.sh copy-to-repo.sh completion.sh
```

5. Enable tab completion by adding this line to your `~/.bashrc`, `~/.zshrc`, or equivalent:
```bash
source "/path/to/my_cursor_rules/completion.sh"  # Update this path
```

6. (Optional) Add aliases to your shell:

Add these lines to your `~/.bashrc`, `~/.zshrc`, or equivalent:
```bash
# Cursor Rules aliases
alias crget='"/path/to/my_cursor_rules/copy-to-project.sh"'  # Get rules from repo
alias crput='"/path/to/my_cursor_rules/copy-to-repo.sh"'     # Put rules into repo
```

Then reload your shell configuration:
```bash
source ~/.bashrc  # or source ~/.zshrc
```

Now you can use:
```bash
crget -list         # List available rules in repo
crget my-rule.mdc   # Copy rule to current project
crput -list         # List rules in current project
crput my-rule.mdc   # Copy rule to repo
```

Tab completion will work with both the full script names and the aliases.

## Usage

### Copying Rules to a Project

Use `copy-to-project.sh` to copy rules from this repository to another project:

```bash
# List available rules in the repository
./copy-to-project.sh -list

# Copy a specific rule to your current project
./copy-to-project.sh my-rule.mdc
```

The script will:
- Create the `.cursor/rules` directory if it doesn't exist (with your permission)
- Validate the file extension (.mdc)
- Ask for confirmation before overwriting existing rules
- Copy the rule to your project

### Copying Rules from a Project

Use `copy-to-repo.sh` to copy rules from a project back to this repository:

```bash
# List available rules in your current project
./copy-to-repo.sh -list

# Copy a specific rule to the repository
./copy-to-repo.sh my-rule.mdc
```

The script will:
- Check if the rule exists in your project
- Validate the file extension (.mdc)
- Ask for confirmation before overwriting existing rules
- Copy the rule to this repository

## Supported File Types

Currently supported file extensions:
- `.mdc` (Cursor rule files)

## Error Handling

The scripts include various safety checks:
- Verifies the configuration is set up correctly
- Ensures the rules repository exists
- Validates file extensions
- Confirms before overwriting files
- Creates directories only with permission

## Contributing

1. Copy rules from your project using `copy-to-repo.sh`
2. Create a pull request with your new rules
3. Include a description of what the rules do

## Notes

- The `config.sh` file is ignored by git to keep your local paths private
- Both scripts require the rules repository path to be set in `config.sh`
- Rules must have the `.mdc` extension