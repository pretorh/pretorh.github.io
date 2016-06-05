---
layout: post
title: "Jekyll Setup"
tags: jekyll configs
---

I wanted to use a basic or a 2 column Jekyll theme, but they were either to basic or had a lot of overhead.
So I used the default theme, made some minor changes and created some scripts to help with post-creation.

## Theme

I tried to find a basic (minimalistic, mostly text, [Stack Problems](https://agusmakmun.github.io/) was probably the closest) or a 2 column Jekyll theme (something like [Lemma](http://neizod.github.io/lemma-theme/index.html)).
But all of them were either to basic (almost just text) or had a lot of overhead involved (far from minimalistic). That or I just got bored.

So I decided to use the default theme, which was actually pretty close to what I wanted, it just needed some minor changes

### Changes to the default theme

#### Add excerpts

Changed the `<li>` element in `index.html` to include the excerpt of each post:
{% highlight jekyll %}
{% raw %}
{{ post.excerpt }}
{% endraw %}
{% endhighlight %}

#### Display tags in post list
Downloaded a [tag icon SVG](https://www.svgimages.com/tag-icon.html)

Created an include file `icon-tag.html` (basically the same as the `span` from the `icon-gibhub.html` file)
{% highlight html %}
{% raw %}
<span class="icon">{% include icon-tag.svg %} {{ include.tag }}</span>
{% endraw %}
{% endhighlight %}

Then, also in the `<li>` element in `index.html`, loop over the tags in the post (`post.tags`) and use the `icon-tag.html` include:

{% highlight jekyll %}
{% raw %}
{% for tag in post.tags %}
    {% include icon-tag.html tag=tag %}
{% endfor %}
{% endraw %}
{% endhighlight %}

#### Add favicon.png
in `_includes/head.html`:
{% highlight html %}
<link rel="shortcut icon" type="image/png" href="/favicon.png">
{% endhighlight %}

#### Minor changes
- Remove RSS
- Fix date time format
    - Changed to [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) dates: `%Y-%m-%d` (2016-05-28) instead of `%b %-d, %Y` (May 28, 2016)

## Creating posts

Created some Perl [scripts](https://github.com/pretorh/jekyll-pub) to help setup and manage Jekyll posts

- Creating drafts
    - `jekyll-new-draft.pl [title]`
- Serving, with draft posts, using Jeykill
    - `jekyll-serve-draft.pl`, which executes `jekyll serve --draft`
- Publishing a draft
    - `jekyll-publish-draft.pl file`
