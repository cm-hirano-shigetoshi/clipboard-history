function fzf_history() {
  export PATH="~/local/bin:${PATH}"
  local readonly CLIPBOARD_HISTORY_FILE="${HOME}/.clipboard_history"
  local readonly TOOL_DIR="$(dirname $(perl -MCwd=realpath -le 'print realpath shift' "$0"))"
  echo $TOOL_DIR >> ~/.debug
  local result
  result=$(fzfyml run ${TOOL_DIR}/clipboard.yml "$CLIPBOARD_HISTORY_FILE")
  if [[ -z "${result}" ]]; then
    return
  fi
  local type
  type=$(head -1 <<< "${result}")
  if [[ "${type}" = "clipboard" ]]; then
    sed '1d' <<< "${result}" \
      | tr '' '\n' \
      | perl ${TOOL_DIR}/del_newline.pl \
      | pbcopy
  elif [[ "${type}" = "edit" ]]; then
    local temp_file
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
}
fzf_history
