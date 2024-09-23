#!/usr/bin/env bash
set -euo pipefail

PATH="$PATH:/opt/homebrew/bin"

readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
bash "$TOOL_DIR/../main/clipboard.sh"
