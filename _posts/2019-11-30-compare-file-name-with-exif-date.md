---
layout: post
date: 2019-11-30T11:55:30+00:00
title: "EXIF photo meta data"
tags: photo linux
---

Read photo take time from command line and compare to file name

## exiv2

Get the date the photo was taken: `exiv2 *.JPG | grep timestamp`

get the string only: `awk -F ' : ' '{print $2}'`

convert into a file-friendly iso8601-like format (replacing `:` in the date with `-` and `:` in the time with `.`): `awk -F ':' '{print $1"-"$2"-"$3"."$4"."$5}'`

```
exiv2 *.JPG | grep timestamp | awk -F ' : ' '{print $2}' | awk -F ':' '{print $1"-"$2"-"$3"."$4"."$5}'
```

## compare with file names

to compare names, remove all non digits: `sed 's|[^0-9]||g'`

run find (grep out files to ignore), xargs, and a [script](https://raw.githubusercontent.com/pretorh/pretorh.github.io/master/scripts/compare-file-name-with-exif-date.sh) to list differences

`find . -type f | grep -v xml | xargs -IN ./compare-file-name-with-exif-date.sh.sh N`
