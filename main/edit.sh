#!/usr/bin/env bash
set -euo pipefail

tmpdir=$1
$EDITOR "$tmpdir/selected"
if [[ -s "$tmpdir/selected" ]]; then
    cat "$tmpdir/selected" | perl -pe 'chomp if eof' | pbcopy
fi