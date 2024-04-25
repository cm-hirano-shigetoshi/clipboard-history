#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Clipboard
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📋

# Documentation:
# @raycast.description post to slack

readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
open /Applications/WezTerm.app/
/Applications/WezTerm.app/Contents/MacOS/wezterm cli spawn -- bash "${TOOL_DIR}/../main/clipboard.sh" > /dev/null
