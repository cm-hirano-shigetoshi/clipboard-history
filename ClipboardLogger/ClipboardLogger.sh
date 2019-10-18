CLIPBOARD_FILE=${HOME}/.clipboard_history

export LANG=ja_JP.UTF-8
latest=""
while true; do
  s=$(pbpaste | tr '\n' '')
  if [[ "$s" != "$latest" ]]; then
    echo "$s" >> "${CLIPBOARD_FILE}"
    latest="$s"
  fi
  sleep 1
done

