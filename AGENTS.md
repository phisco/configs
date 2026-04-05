# Code helpers
- When reviewing PRs, if asked to use golangci-lint, always use `golangci-lint run --fix --new --new-from-rev=$(git merge-base upstream/main HEAD)`. If not told differently. Ask the user confirmation.
- Use agents and run tasks in parallel when it makes sense. If possible, make 
- Never mention claude in commit messages.

# Scratch files
- Use the `.phisco/` directory at the repo root for temporary scratch files, notes, and intermediate artifacts. This directory is globally gitignored.

# Nix
You can use nix to set up a development environment and install dependencies, prefer that to install system-wide packages using tools such as pip3 or brew.

# Testing

- Always try to write testable code, defining interfaces that can be mocked later where applicable.
- If there are already tests defined for the project, conform to their style. E.g. in Crossplane, we mostly use go-cmp to compare results and mostly write table-driven tests, except for e2es, where we do something more like BDD using a dedicated library.

# Git

- Never mention claude in commit messages.
- Always signoff commits, "git commit --gpg-sign --signoff"
- Most of the times I want to use a dedicated feature branch, so if I'm on main/master, check if I forgot to checkout a branch before committing. Once I confirm we are on the right branch, don't ask again for that session.
- Always check we have pulled latest changes on the branch before proceeding with a new feature.
