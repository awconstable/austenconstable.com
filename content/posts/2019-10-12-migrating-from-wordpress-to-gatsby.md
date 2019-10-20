---
author: awconstable
comments: true
date: 2019-10-12
layout: post
slug: 2019-10-12-migrating-from-wordpress-to-gatsby
title: Migrating from WorkPress.com to Gatsby, CircleCI and AWS Hosting
categories:
- Code
tags:
- blog
- gatsby
---

It's my WordPress.com renewal time and whilst the service has been fine the whole paradigm and technical approach is a little dated. There's also some great free or very cheap services for personal site hosting out there and my preference is to have everything under source control and to follow CI/CD principles. There’s also a whole raft of static site generators which have matured significantly over the last few years which enable the above - so now seems like as good a time as any to migrate away.

## Requirements

* Everything must be under source control
* Follow CI/CD principles and tooling
* Minimise cost where possible
* Updates must be possible remotely via iOS
* The migration should be seamless. That is:
  * Current URL's should still work
  * Photo's and images currently hosted on WordPress must migrate
  * Posts with embedded Google Maps must still operate
  * Google Analytics should be used to monitor usage
  * Existing comments must migrate
  * The migration must not require lots of manual change. i.e. it's scripted

## Switch all WordPress Gallery photo's to individual images

TIP: to save looking through each of your posts. Complete steps 1 and 2 below and then run the following on the Markdown output:

```bash
grep -l '\[gallery' *
```

## Export all posts and images from WordPress.com

* Login to the admin console
* Navigate to Tools > Export

## Use ExitWP to convert Wordpress XML to Markdown

[ExitWP](https://github.com/thomasf/exitwp)

## Move and rename Markdown files

From the output directory of ExitWP use the following script to move posts to a directory structure which preserves WordPress' url scheme.

```bash
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

```bash
find . -iname '*.jpg' -exec convert {} -verbose -resize 1000000@ {} \;
```

## Place the images in the root static folder

```bash
mv images/* static/images/
```

## Switch your posts to use the local images rather than WordPress hosted

```bash
find . -type f -exec sed -i '' 's=https://austenconstable.files.wordpress.com=../../../images=g' {} \;
```

## Manually update any captions

```bash
# figure out the list of posts with captions
grep -rl '\[caption' *
```

## Switch Google Maps tags to iframes

```bash
find . -type f -exec sed -i '' 's/\[googlemaps /<iframe src="/g' {} \;
find . -type f -exec sed -i '' 's/w=640&h=480\]/w=640&h=480" width="640" height="480"><\/iframe>/g' {} \;
find . -type f -exec sed -i '' 's/w=425&h=350\]/w=425&h=350" width="425" height="350"><\/iframe>/g' {} \;
find . -type f -exec sed -i '' 's/h=350\]h=350/h=350/g' {} \;
```

Wait for part 2 for deployment and remote updates via iOS.
