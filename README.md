# Quick Clip

A quick-access panel for your favorite commands and text snippets. Keep your most-used commands, code snippets, and text at your fingertips — click to copy to clipboard instantly.

## Features

- **Bar icon** that opens a snippets panel on click
- **Click to copy** — tap any snippet to copy its content to clipboard with visual feedback
- **Add new snippets** — press the `+` button to add a label and content
- **Swipe to delete** — drag a snippet left to reveal the delete zone and remove it
- **Persistent storage** — your snippets are saved and survive restarts
- **CLI control** — add snippets or toggle the panel via IPC commands

## Usage

1. Click the Quick Clip icon in your bar to open the panel
2. Press `+` to add a new snippet with a label and content
3. Click any snippet to copy it to your clipboard
4. Swipe a snippet to the left to delete it

## IPC Commands

```bash
# Toggle the panel
qs -c noctalia-shell ipc call plugin:quick-clip toggle

# Add a snippet via CLI
qs -c noctalia-shell ipc call plugin:quick-clip add "My Label" "my content to copy"
```
