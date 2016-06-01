#!/bin/sh

IFS=$'\n'

old_size=$(find . -type f -name '*.png' -exec ls -l \{\} \; | awk '{sum += $5}END{print sum}')

for png in $(find . -type f -name '*.png'); do
	pngquant --speed 1 --skip-if-larger --ext .png --force "$png"
	optipng -strip all -o7 -zm1-9 "$png"
done

new_size=$(find . -type f -name '*.png' -exec ls -l \{\} \; | awk '{sum += $5}END{print sum}')

echo "Finished: $old_size -> $new_size"
