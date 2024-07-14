readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
readonly CLIPBOARD_FILE="${HOME}/.local/share/clipboard/history"
readonly CLIPBOARD_RAW_FILE="${HOME}/.local/share/clipboard/history.raw"

export BAT_THEME="Dracula"

tmpdir="$1"

selected=$(tac "${CLIPBOARD_RAW_FILE}" | \
            grep -v '^\s*$' | \
            awk '!a[$0]++' | \
            tee "${CLIPBOARD_FILE}" | \
            bat --color always --plain -l python | \
            fzf \
              --ansi \
              --multi \
              --no-sort \
              --expect "enter,alt-enter" \
              --preview "echo {} | tr '' '\n' | bat --color always --plain -n -l python" \
              --preview-window "wrap:up:65%" \
          )
if [[ -n "${selected}" ]]; then
    header="$(head -1 <<< "${selected}")"
    content="$(sed 1d <<< "${selected}" | tr '' '\n')"
    if [[ "${header}" = "alt-enter" ]]; then
        echo "${content}" > "$tmpdir/selected"
    else
        echo "${content}" | perl -pe 'chomp if eof' | pbcopy
    fi
fi

date > "$tmpdir/done"

