#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title NextClip
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ⬇️

# Documentation:
# @raycast.description post to slack

CLIPBOARD_FILE="${HOME}/.local/share/clipboard/history"
CLIPBOARD_RAW_FILE="${HOME}/.local/share/clipboard/history.raw"
CLIPBOARD_CASHE_FILE="${HOME}/.local/share/clipboard/history.cache"

VOLATTILITY_SECONDS=10
CASHE_N=100

function prepare_cache {
    now=$(date +%s)
    cache_ts=$(/usr/bin/stat -f"%m" "${CLIPBOARD_CASHE_FILE}" 2>/dev/null)
    diff=$((now - cache_ts))
    if [[ $diff -gt $VOLATTILITY_SECONDS ]]; then
        tac ${CLIPBOARD_RAW_FILE} | awk '!a[$0]++' | grep -v '^$' | head -${CASHE_N} > ${CLIPBOARD_CASHE_FILE}
        echo '1' >> ${CLIPBOARD_CASHE_FILE}
    fi
}

function get_next_index {
    index=$(tail -1 ${CLIPBOARD_CASHE_FILE})
    echo $((index - 1))
}

function get_text {
    index=$1
    head -$index ${CLIPBOARD_CASHE_FILE} | tail -1
}

function decrement_index {
    index=$1
    texts=$(sed '$d' ${CLIPBOARD_CASHE_FILE})
    { echo "$texts"; echo "$index"; } > ${CLIPBOARD_CASHE_FILE}
}

prepare_cache
index=$(get_next_index)
if [[ $index -le 0 ]]; then
    index=1
fi
text=$(get_text $index)
echo "$index: $text" | cut -c -400
echo $text | perl -pe 'chomp if eof' | tr '' '\n' | pbcopy
decrement_index $index
