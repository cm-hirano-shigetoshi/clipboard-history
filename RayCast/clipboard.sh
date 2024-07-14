#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Clipboard
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📋

# Documentation:
# @raycast.description Open ClipboardHistory on Wezterm.

tmpdir=$(mktemp -d)
mkfifo "$tmpdir/done"
readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
pane_id=$(/Applications/WezTerm.app/Contents/MacOS/wezterm cli split-pane -- bash ${TOOL_DIR}/../main/clipboard.sh ${tmpdir})
/Applications/WezTerm.app/Contents/MacOS/wezterm cli zoom-pane --pane-id $pane_id
open /Applications/WezTerm.app/

timeout 3600 cat "$tmpdir/done" >/dev/null
if [[ -e "$tmpdir/selected" ]]; then
    "$HOME/bin/main/execute-on-wezterm" "${EDITOR-vim} $tmpdir/selected"
fi
