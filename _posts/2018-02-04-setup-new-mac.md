---
layout: post
date: 2018-02-04T17:14:06Z
title: "Setup a new Mac"
tags: mac reference
---

Below is a semi-ordered list of installation/configuration steps for a new Mac

### update mac os first

- Usually the largest single thing to download
- Have had issues with homebrew setups after an upgrade, so get it out of the way first

### basics

- Firefox
- Dropbox
- password manager

### development

- iterm2
    - bind `§` key to hex code `0x1b` (escape) as this allows pressing `§` in vim
- docker
- macs fan control (previoiusly used smcFanControl)
- android studio

### homebrew

install homebrew itself and setup some basic tools

`brew install tmux git ruby vim zsh`

### create symlink docs:

`ln -s Documents/ docs`

- links `~/docs` to `~/Documents`
- shorter name, and I prefer setting zsh to have case-sensitive auto complete
- this makes `~/d` auto complete to `~/docs` (vs `~/Doc`)

### ssh-keygen

create a ssh key for bitbucket, github

### dot files:

`GIT_SSH_COMMAND="ssh -i ~/.ssh/github" git clone git@github.com:pretorh/dotfiles.git`

(use `GIT_SSH_COMMAND` since the dot files will install the config for the keys to use)

`brew  install stow coreutils` (`stow` and gnu date required)
