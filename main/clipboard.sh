readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
readonly CLIPBOARD_FILE="${HOME}/.clipboard_history"
readonly CLIPBOARD_RAW_FILE="${HOME}/.clipboard_history.raw"

selected=$(tac "${CLIPBOARD_RAW_FILE}" | \
            grep -v '^\s*$' | \
            awk '!a[$0]++' | \
            tee "${CLIPBOARD_FILE}" | \
            fzf \
              --multi \
              --no-sort \
              --expect "enter,alt-enter" \
              --preview "echo {} | tr '' '\n' | bat --color always --plain -n -l python" \
              --preview-window "wrap:65%" \
          )
if [[ -n "${selected}" ]]; then
    header="$(head -1 <<< "${selected}")"
    content="$(sed 1d <<< "${selected}" | tr '' '\n')"
    if [[ "${header}" = "alt-enter" ]]; then
        tmpdir=$(mktemp -d)
        echo "${content}" > "$tmpdir/selected"
        vim "$tmpdir/selected"
        if [[ -s "$tmpdir/selected" ]]; then
            cat "$tmpdir/selected" | perl -pe 'chomp if eof' | pbcopy
        fi
    else
        echo "${content}" | perl -pe 'chomp if eof' | pbcopy
    fi
fi

