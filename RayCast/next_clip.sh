#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title NextClip
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ⬇️

# Documentation:
# @raycast.description post to slack

CLIPBOARD_HISTORY_FIILE="$HOME/.clipboard_history"
CLIPBOARD_RAW_FIILE="$CLIPBOARD_HISTORY_FIILE.raw"
CLIPBOARD_CASHE_FIILE="$CLIPBOARD_HISTORY_FIILE.cache"

VOLATTILITY_SECONDS=10
CASHE_N=100

function prepare_cache {
    now=$(date +%s)
    cache_ts=$(/usr/bin/stat -f"%m" "${CLIPBOARD_CASHE_FIILE}" 2>/dev/null)
    diff=$((now - cache_ts))
    if [[ $diff -gt $VOLATTILITY_SECONDS ]]; then
        tac ${CLIPBOARD_RAW_FIILE} | awk '!a[$0]++' | grep -v '^$' | head -${CASHE_N} > ${CLIPBOARD_CASHE_FIILE}
        echo '1' >> ${CLIPBOARD_CASHE_FIILE}
    fi
}

function get_next_index {
    index=$(tail -1 ${CLIPBOARD_CASHE_FIILE})
    echo $((index - 1))
}

function get_text {
    index=$1
    head -$index ${CLIPBOARD_CASHE_FIILE} | tail -1
}

function decrement_index {
    index=$1
    texts=$(sed '$d' ${CLIPBOARD_CASHE_FIILE})
    { echo "$texts"; echo "$index"; } > ${CLIPBOARD_CASHE_FIILE}
}

prepare_cache
index=$(get_next_index)
if [[ $index -le 0 ]]; then
    echo "⚠️"
else
    text=$(get_text $index)
    echo "$index: $text" | cut -c -400
    echo $text | perl -pe 'chomp if eof' | tr '' '\n' | pbcopy
    decrement_index $index
fi
