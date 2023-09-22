#!/usr/bin/env bash

temp_file=$(mktemp "/tmp/clipboard_history.XXXXXX")
ORG_IFS="$IFS"
IFS=$'\n'
echo "$*" | tr '' '\n' > $temp_file
IFS="$ORG_IFS"
vim $temp_file
if [[ -n "$temp_file" ]]; then
    cat $temp_file | perl -pe 'chomp if eof' | pbcopy
fi

