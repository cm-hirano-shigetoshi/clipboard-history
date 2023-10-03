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
              --preview "echo {} | tr '' '\n' | bat --color always --plain -n -l python" \
              --preview-window "wrap:65%" \
              --bind "alt-e:execute-silent(tmux new-window bash '${TOOL_DIR}/open_vim.sh' {+})" |\
            tr '' '\n')
if [[ -n "${selected}" ]]; then
    echo "${selected}" | perl -pe 'chomp if eof' | pbcopy
fi

