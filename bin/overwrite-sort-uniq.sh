#!/bin/bash

tmpfile="/tmp/$$"

function sort_uniq {
  local file=$1
  local tmpfile="/tmp/$(basename $file)"
  trap "rm \"$tmpfile\"; exit 1" 2
  sort "$file" | uniq > "$tmpfile"
  mv "$tmpfile" "$file"
}

for file in $@; do
  sort_uniq "$file" &
done

wait
