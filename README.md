# Beautified Terminal
<img width="1381" height="890" alt="Screenshot From 2026-04-09 01-22-48" src="https://github.com/user-attachments/assets/d275813c-739e-4446-a5ea-4d88d06f3e6d" />

<img width="1381" height="890" alt="Screenshot From 2026-04-09 01-24-31" src="https://github.com/user-attachments/assets/a4576ea1-f416-4bb8-8f17-c493ae92593f" />

The above pictures are running on Ghostty on Ubuntu 25.10 displaying current language version and git status across different directories.

A beautiful terminal setup running zsh with starship, zinit on either ghostty or alacritty to provide a fast and efficient experience.
## Features

- **Cross-platform** - Works on macOS, Linux, and Windows (with limitations)
- **Automated Installation** - Installs all dependencies automatically
- **Starship Prompt** - Installs Rust (if needed) and Starship
- **Zsh Ecosystem** - Installs Oh My Zsh, Zinit, and popular plugins
- **Configuration Management** - Copies your existing config files to the right places

> **Note:** The script will **not** create default configs. You must provide your own configuration files.

## Installation

1. **Save the script below** as `install.sh`
2. **Place your config files** in the same directory
3. **Make the script executable**: `chmod +x install.sh`
4. **Run the script**: `./install.sh`

## Starship features implemeted
1. View git status
2. Time per each command
3. Primary language with version
4. Current directory

## Zinit
Allows plugin to laod after loading the zsh terminal to speed up the process of writing commands


##### Credits to the rightful owners of all the tools used such as starship, ghostty, alacritty, zinit etc. 

