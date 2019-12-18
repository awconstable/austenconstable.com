---
author: awconstable
comments: true
date: 2019-10-12
layout: post
slug: 2019-10-12-migrating-from-wordpress-to-gatsby
title: Migrating from WorkPress.com to Gatsby, CircleCI and AWS Hosting - Part 1
categories:
- Code
tags:
- blog
- gatsby
- JAMStack
---

It's my WordPress.com renewal time and whilst the service has been fine the whole paradigm and technical approach is a little dated. There's also some great free or very cheap services for personal site hosting out there and my preference is to have everything under source control and to follow CI/CD principles. The JAMStack movement has really matured significantly and there’s a whole raft of static site generators which enable the above - so now seems like as good a time as any to migrate away.

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

I selected Gatsby because it has a mature offering which continues to be maintained, an active community and I wanted to learn more about JavaScript and React.

## Install Gatsby

```bash
brew install node gatsby-cli
```

## Install Gatsby Starter Blog

```bash
# create a new Gatsby site using the blog starter
gatsby new my-blog-starter https://github.com/gatsbyjs/gatsby-starter-blog
cd my-blog-starter/
gatsby develop
```

## Switch all WordPress Gallery photo's to individual images

TIP: to save looking through each of your posts. Complete the next 2 steps below and then run the following on the Markdown output:

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

_Update 06/11/2019: I misunderstood the role of directories in url scheme. In fact the url is specified by the slug in Front Matter. Ultimately I did change my url schema for simplicity. The bash script below may still be useful to organise your posts._

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
find . -type f -exec sed -i '' 's=https://austenconstable.files.wordpress.com=../images=g' {} \;
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

## Run up Gatsby

Now we have the content in place it's time to run up Gatsby

```bash
gatsby develop
```

Navigate to [http://localhost:8000](http://localhost:8000) and you should see your new blog!

---

In [part two](/2019-11-06-migrating-to-gatsby-part2) we'll finish the migration and build a continuous deployment pipeline to deploy to production.
