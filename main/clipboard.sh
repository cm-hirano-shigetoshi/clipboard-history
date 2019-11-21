export PATH="~/local/bin:${PATH}"
readonly CLIPBOARD_HISTORY_FILE="${HOME}/.clipboard_history"
readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
echo $TOOL_DIR >> ~/.debug
result=$(fzfyml run ${TOOL_DIR}/clipboard.yml "$CLIPBOARD_HISTORY_FILE")
if [[ -n "${result}" ]]; then
  type=$(head -1 <<< "${result}")
  if [[ "${type}" = "clipboard" ]]; then
    sed '1d' <<< "${result}" \
      | tr '' '\n' \
      | perl ${TOOL_DIR}/del_newline.pl \
      | pbcopy
  elif [[ "${type}" = "edit" ]]; then
    temp_file=$(mktemp "/tmp/clipboard_history.XXXXXX")
    sed '1d' <<< "${result}" \
      | tr '' '\n' \
      | perl ${TOOL_DIR}/del_newline.pl \
      > ${temp_file}
    ${EDITOR-vim} ${temp_file}
    if [[ -s ${temp_file} ]]; then
      cat ${temp_file} | pbcopy
    fi
  fi
fi

