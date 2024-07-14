#!/usr/bin/env bash
set -euo pipefail

readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
readonly WEZTERM_APP="/Applications/WezTerm.app"
readonly WEZTERM_APP_DIR="${WEZTERM_APP}/Contents/MacOS"
readonly EDITOR_WAIT_SECOND=3600

function wezterm_run() {
    pane_id=$("${WEZTERM_APP_DIR}/wezterm" cli split-pane -- "$@")
    "${WEZTERM_APP_DIR}/wezterm" cli zoom-pane --pane-id $pane_id
}

function wezterm_run_shell() {
    pane_id=$("${WEZTERM_APP_DIR}/wezterm" cli split-pane)
    "${WEZTERM_APP_DIR}/wezterm" cli zoom-pane --pane-id ${pane_id}
    echo "$@; exit" | "${WEZTERM_APP_DIR}/wezterm" cli send-text --pane-id ${pane_id} --no-paste
}

tmpdir=$(mktemp -dt 'ClipboardHistory.XXXXXXXX')
mkfifo "$tmpdir/done"

wezterm_run "${TOOL_DIR}/../main/clipboard.sh" "${tmpdir}"
open "${WEZTERM_APP}"

timeout $EDITOR_WAIT_SECOND cat "$tmpdir/done" >/dev/null
if [[ -e "$tmpdir/edit" ]]; then
    wezterm_run_shell "${TOOL_DIR}/edit.sh" "$tmpdir/edit"
fi

