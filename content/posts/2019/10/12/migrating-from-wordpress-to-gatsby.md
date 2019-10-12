---
author: awconstable
comments: true
date: 2019-10-12
layout: post
slug: migrating-from-wordpress-to-gatsby
title: Migrating from Workpress.com to Gatsby, CircleCI and AWS Hosting
categories:
- Code
tags:
- blog
---

It's my Wordpress renewal time and $48+tax/year seems quite a lot for a service I rarely use. There's also some great free or very cheap services for personal site hosting out there and my preference is to have everything under source control anyway. 

## Requirements
* Everything must be under source control
* The migration should be seamless. That is:
    * Current URL's must still work
    * Photo's and images currently hosted on Wordpress must migrate
    * Posts with embedded Google Maps must still operate
    * Google Analytics should continue to be used to monitor usage
    * The migration must not require lots of manual change. i.e. it's scripted
    * The new system must use CI/CD

## Switch all Wordpress Gallery photo's to individual images

TODO: Insert screen recording

TIP: to save looking through each of your posts. Complete steps 1 and 2 below and then run ```grep -l '\[gallery' *``` on the Markdown output.

## Export all posts and images from Wordpress.com
    * Login to the admin console
    * Navigate to Tools > Export

## Use ExitWP to convert Wordpress XML to Markdown

[ExitWP](https://github.com/thomasf/exitwp)

## Move and rename Markdown files
From the output directory of ExitWP use the following script to move posts to a directory structure which mirror's Wordpress' url scheme.

```
#!/bin/bash
regex="([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*).markdown"
for file in *.markdown
do
	if [[ $file =~ $regex ]]
	then
	  year="${BASH_REMATCH[1]}"
	  month="${BASH_REMATCH[2]}"
	  day="${BASH_REMATCH[3]}"
	  name="${BASH_REMATCH[4]}"
	  echo "${year}/${month}/${day}/${name}.md"
	else
	  echo "$file doesn't match" >&2
	fi
	dir="$year/$month/$day"
	if [ -d "${dir}" ]
	then
    	  echo "directory ${dir} exists"
	else
           mkdir -p $dir
    	fi
	mv $file $dir/$name.md
done
```

## Resize images
```
find . -iname '*.jpg' -exec convert {} -verbose -resize 1000000@ {} \;
```

## Place the images in the root staic folder


## Switch your posts to use the local images rather than Wordpress hosted.
```
find . -type f -exec sed -i '' 's=https://austenconstable.files.wordpress.com=../../../images=g' {} \;
```

## Manually update any captions
```
grep -rl '\[caption' *
```