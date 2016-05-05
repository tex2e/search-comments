#!/bin/bash

tmpfile="/tmp/$$"
trap "rm /tmp/$$; exit 1" 2

for file in $@; do
  sort "$file" | uniq > "$tmpfile"
  mv "$tmpfile" "$file"
done
