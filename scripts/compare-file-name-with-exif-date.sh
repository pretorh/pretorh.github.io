#!/usr/bin/bash

exif_date=$(exiv2 "$1" | grep timestamp | awk -F ' : ' '{print $2}' | awk -F ':' '{print $1"-"$2"-"$3"."$4"."$5}')
# ignore failed to read
[ -z "$exif_date" ] && exit 0
[ "$exif_date" = "--.." ] && exit 0

# get only the digits in the exif date
date_simple=${exif_date//[^0-9]/}

# get only the digits in the filename, and only the first 14 (to ignore enumarations)
filename_digits=$(basename "$1" | sed 's|[^0-9]||g')
filename_simple=${filename_digits:0:14}
[ ${#filename_simple} -lt 8 ] && exit 0

diff=$((date_simple-filename_simple))
max_diff=${MAX_DIFF:-60}
if [ $diff -gt "$max_diff" ] || [ $diff -lt "-$max_diff" ] ; then
    echo "$1 ($filename_simple $exif_date) date diff of $diff"
elif [ "$date_simple" != "$filename_simple" ] ; then
    echo "$1 ($exif_date) not exact"
fi
