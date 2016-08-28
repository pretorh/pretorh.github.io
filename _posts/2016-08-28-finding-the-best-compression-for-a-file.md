---
layout: post
date: 2016-08-28T17:07:31Z
title: "Finding the best compression for a file"
tags: compression micro-optimization
---

Files compress better depending on the compression method. Sometimes it does not even compress, and the raw file is the smaller than any compressed file. So what compression method should be used to compress a file?

[tl;dr](#tldr)

# Compression methods

`gzip`, `bzip2` and `xz` accept similar command line arguments:

- `-c` compress to `stdout`. keeps the original file
- `-9` use best compression

`compress` accepts the `-c` flag to output to `stdout` ([compress])

# Getting the number of bytes

`wc` counts the number of lines, words, bytes or characters in a file ([wc])
- `-c` outputs the number of bytes in a file or `stdin`

# Putting it together

`wc -c $FILE` will include the filename in the output, which may not be what you want. To ouptut just the bytes, use `cat` with `wc`:
{% highlight shell %}
cat $FILE | wc -c
{% endhighlight %}

To use best compression on `gzip` and count the number of bytes in the compressed output:
{% highlight shell %}
gzip -c9 $FILE | wc -c
{% endhighlight %}

To get the best compression method for a file using `bzip2`, `gzip`, `xz` and `compress` (or uncompressed): <a name="tldr"></a>
{% highlight shell %}
bzip2 -c9 $FILE | wc -c
gzip -c9 $FILE | wc -c
xz -c9 $FILE | wc -c
compress -c $FILE | wc -c
cat $FILE | wc -c
{% endhighlight %}

Links:

- [gzip](https://www.gnu.org/software/gzip/)
    ([invoking](https://www.gnu.org/software/gzip/manual/html_node/Invoking-gzip.html#Invoking-gzip))
- [bzip2](http://bzip.org/)
    ([invoking](http://bzip.org/1.0.5/bzip2.txt))
- [xz](http://tukaani.org/xz/)
- [(n)compress](https://github.com/vapier/ncompress)

[wc]: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/wc.html
[compress]: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/compress.html
