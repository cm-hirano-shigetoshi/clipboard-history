#!/usr/bin/env bash
set -eu

export EDITOR="nvim"

tmpdir=$(mktemp -dt 'ClipboardHistory.XXXXXXXX')
mkdir -p "${tmpdir}"
pbpaste > "${tmpdir}/clipboard"
"${EDITOR}" "${tmpdir}/clipboard"

if [[ -s "${tmpdir}/clipboard" ]]; then
    cat "${tmpdir}/clipboard" | perl -pe 'chomp if eof' | pbcopy
fi
