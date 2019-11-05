---
author: awconstable
comments: true
date: 2008-09-02 15:35:16+00:00
layout: post
link: http://austenconstable.com/?p=58
published: false
slug: 2008-09-02-recursive-search-and-replace-on-the-linux-command-line
title: 'HOWTO: Recursive search and replace on the Linux command line'
wordpress_id: 58
categories:
- HOWTO
- Linux
tags:
- grep
- sed
---

The 'traditional' way to search and replace on the command line was to use some combination of grep/find/perl/sed etc. Which offers great flexibility but at the end of the day can turn into a right pain in order to complete a simple task. _Turns out only to be a pain in the ass if you don't know or can't remember the correct syntax! _


Recently I stumbled across rpl. ([http://freshmeat.net/projects/rpl/](http://freshmeat.net/projects/rpl/)) It's a nice little text replacement utility which is as simple as:

    
    rpl -R search replace *


Although rpl is easy, the other alternatives are hardly difficult. (At least once you know them)

For non-recursive search and replace try: [Perl](http://www.liamdelahunty.com/tips/linux_search_and_replace_multiple_files.php) or [sed](http://gabeanderson.com/2008/02/01/unixlinux-find-replace-in-multiple-files/). (At some point I'm sure I'll get around to finding recursive Perl and sed alternatives.)
