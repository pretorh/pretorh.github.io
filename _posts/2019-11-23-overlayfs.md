---
layout: post
date: 2019-11-23T08:30:33+00:00
title: "Overlayfs"
tags: linux
---

Merges a readonly base directory (`lower`) and a new directory (`upper`) into a writable directory (`merged`)
Changes made in this writable directory are saved in `upper`

## test

### merged

setup:

```
mkdir lower
mkdir upper
mkdir merged
mkdir work
sudo mount -t overlay overlay -o lowerdir=lower,upperdir=upper,workdir=work merged
```

files in `lower` or `upper` are available in `merged`

```
touch lower/1
touch upper/2
ls -1 merged
```

creating a file in `merged` will create it in `upper`

```
touch merged/3
ls -1 upper
```

### file changes

When a file from `lower` is changed in `merged`, the change is persisted in `upper`

```
echo "from lower" > lower/change-me
cat merged/change-me

echo "changed in merged" > merged/change-me
cat lower/change-me
cat upper/change-me
```

### deleting files

What happens when a file from `lower` is deleted in `merged`?

```
touch lower/delete-me
ls -1 merged/
rm -v merged/delete-me
```

still in `lower` (readonly): `ls -1 lower`

but it becomes a character special file: `stat upper/delete-me`

### cleanup

```
sudo umount merged
sudo rm -r work
rmdir merged
```

output of `find . -type f | sort`:
```
./lower/1
./lower/change-me
./lower/delete-me
./upper/2
./upper/3
./upper/change-me
```

## links

- [Arch wiki](https://wiki.archlinux.org/index.php/Overlay_filesystem)
- [how containers work: overlay filesystems](https://twitter.com/b0rk/status/1196469601938411521)
