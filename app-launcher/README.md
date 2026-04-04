# App Launcher

A Noctalia plugin that adds a quick-access panel to your bar for launching apps with single or multi-command sequences.

## Features

- Bar icon that opens a panel with your configured apps
- Multi-command support — chain commands together (e.g., activate venv then launch app)
- Click an app in the panel to execute all its commands in sequence
- Easy configuration through the plugin settings
- Uses system icons from your icon theme

## Usage

1. Click the app launcher icon in your bar to open the panel
2. Click any app in the panel to run its commands
3. Configure apps in settings:
   - **Name**: Display name in the panel
   - **Icon**: Icon name from your system theme
   - **Commands**: One or more commands that run in order when clicked

## Example: ComfyUI

Instead of manually running multiple commands:
```bash
cd ~/comfyui
source venv/bin/activate
python main.py
```

Add it as a single entry with three command steps. One click runs them all.

## Configuration

Each app entry has:
- `name`: Display name in the panel
- `icon`: Icon name from the system icon theme
- `commands`: Array of shell commands executed in order
