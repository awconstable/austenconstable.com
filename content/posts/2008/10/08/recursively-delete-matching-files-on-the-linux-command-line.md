---
author: awconstable
comments: true
date: 2008-10-08 09:18:11+00:00
layout: post
link: http://austenconstable.com/?p=67
published: false
slug: 2008-10-08-recursively-delete-matching-files-on-the-linux-command-line
title: 'HOWTO: Recursively delete matching files on the Linux command line'
wordpress_id: 67
categories:
- Linux
tags:
- find
- grep
- Perl
---

An easy way to recursively delete files matching a particular pattern is to use this one liner:

```bash
find | grep "search" | perl -nle unlink
```

UPDATE - Another handy one liner to recursively delete directories is:

```bash
rm -rf `find . -type d -name .svn`
```

Obviously replacing ".svn" with whatever your directories are called.
