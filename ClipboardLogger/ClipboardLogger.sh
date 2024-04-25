CLIPBOARD_RAW_FILE="${HOME}/.local/share/clipboard/history.raw"
mkdir -p "$(dirname ${CLIPBOARD_RAW_FILE})"

export LANG=ja_JP.UTF-8
latest=""
while true; do
  s=$(pbpaste | tr '\n' '')
  if [[ "$s" != "$latest" ]]; then
    echo "$s" >> "${CLIPBOARD_RAW_FILE}"
    latest="$s"
  else
    sleep 1
  fi
done

