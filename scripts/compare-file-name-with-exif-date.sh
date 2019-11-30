#!/usr/bin/sh

exif_date=$(exiv2 "$1" | grep timestamp | awk -F ' : ' '{print $2}' | awk -F ':' '{print $1"-"$2"-"$3"."$4"."$5}')
[ -z "$exif_date" ] && exit 0

date_simple=$(echo "$exif_date" | sed 's|[^0-9]||g')
filename_simple=$(basename "$1" | sed 's|[^0-9]||g')

if [ "$date_simple" != "$filename_simple" ] ; then
    echo "$1 ($exif_date)"
fi
