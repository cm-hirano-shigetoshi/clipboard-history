#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Clipboard
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📋

# Documentation:
# @raycast.description Open ClipboardHistory on Wezterm.

readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
pane_id=$(/Applications/WezTerm.app/Contents/MacOS/wezterm cli split-pane -- bash ${TOOL_DIR}/../main/clipboard.sh)
/Applications/WezTerm.app/Contents/MacOS/wezterm cli zoom-pane --pane-id $pane_id
open /Applications/WezTerm.app/
