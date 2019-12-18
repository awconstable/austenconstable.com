---
comments: true
date: 2019-11-06
layout: post
slug: 2019-11-06-migrating-to-gatsby-part2
title: Migrating from WorkPress.com to Gatsby, CircleCI and AWS Hosting - Part 2
categories:
- Code
tags:
- blog
- gatsby
- JAMStack
---

In [part one](/2019-10-12-migrating-from-wordpress-to-gatsby) we got as far as exporting the WordPress content and preparing the markdown for use with [Gatsby](https://www.gatsbyjs.org/).
In part two, we'll complete the migration and launch the site.

## Create a continuous deployment pipeline

We'll put together a simple continuous deployment pipeline using [CircleCI](https://circleci.com/).

Since it'll just be me working on the blog we'll keep the workflow super simple and dispense with a branching strategy altogether. Posts will be committed directly into master and immediately deployed to production assuming they pass our tests.

Rather than running through the CircleCI setup step by step, take a look at the config file [here](https://github.com/awconstable/austenconstable.com/blob/master/.circleci/config.yml)

There's 5 steps in the build pipeline. The first 3 deal with the infrastructure which I'll document in more detail in the next section. The final 2 stages build and test the gatsby web app and then deploy to the live infrastructure.

### Gatsby Build Step

![Gatsby Build Step](../images/2019/12/gatsby-build-1.png)

During the build set we:

* Spin up an environment
* Checkout the code
* Use npm to install the gatsby cli
* Use apt to install htmlproofer dependencies
* Make a public directory for our build output
* Echo the build number into a text file so that we know what's deployed where
* Use npm to install all of our gatsby dependencies
* Install htmlproofer
* Validate the site with htmlproofer (Ignoring offline html from the proofer checks)

```bash
htmlproofer public --allow-hash-href --check-html \
          --empty-alt-ignore --disable-external \
          --file-ignore public/offline-plugin-app-shell-fallback/index.html
```

### Gatsby Deployment Step

![Gatsby Deploy Step](../images/2019/12/gatsby-build-2.png)

During the deployment we:

* Install the AWS cli and S3 Orb's
* Deploy to an S3 bucket using the AWS S3 Orb

```yaml
    - aws-s3/sync:
        from: public
        to: ${DEPLOYMENT_URI}
        aws-access-key-id: AWS_ACCESS_KEY_ID
        aws-secret-access-key: AWS_SECRET_ACCESS_KEY
        aws-region: AWS_REGION
        arguments: |
          --acl public-read \
          --cache-control "max-age=86400" \
          --delete
```

* Invalidate the Cloudfront cache

```bash
aws cloudfront create-invalidation --distribution-id ${CDN_DISTRIBUTION_ID} --paths "/*";
```

## Setup AWS Hosting using Terraform

We'll be hosting on AWS using an S3 bucket for storage and CloudFront as the CDN. *Note: It's important to set the S3 bucket's Static Website Hosting Endpoint as the CloudFront origin in order to enable 301/302 serverside redirects* See the Gatsby article on deploying to CloudFront [here](https://www.gatsbyjs.org/docs/deploying-to-s3-cloudfront/).

On the Terraform front I used the excellent [terraform with circleci example project](https://github.com/fedekau/terraform-with-circleci-example) by [Federico Kauffman](https://github.com/fedekau) as a starting point. My end result is [here](https://github.com/awconstable/austenconstable.com/tree/master/infra) and the getting started guide is [here](https://github.com/awconstable/austenconstable.com/tree/master/infra).

The three steps of the CD pipeline that handle infrastructure do the following:

1. 'Test' the format of the terraform files using terraform fmt.
2. Run a terraform plan and store the output to a file.
3. Run a terraform apply using the plan output.

See the CircleCI config [here](https://github.com/awconstable/austenconstable.com/blob/master/.circleci/config.yml)

## Migrate my custom domain

In order to move my custom domain name ([austenconstable.com](austenconstable.com)) to AWS the following steps were required:

1. Remove custom domain from WordPress
1. Migrate domain hosting to Google Domains
1. Setup email forwarding
1. Define DNS zone and records on AWS using Terraform
1. Switch the DNS to AWS

## Added Google Analytics

Install the gatsby-plugin-google-analytics plugin using npm

```bash
npm i --save-prod gatsby-plugin-google-analytics
```

Configure the plugin in your gatsby-config.js, adding your tracking ID

```javascript
    {
      resolve: `gatsby-plugin-google-analytics`,
      options: {
        trackingId: "UA-XXXXX-X"
      }
    },
```

## Add a 404 page

A working [404 page](https://www.gatsbyjs.org/docs/add-404-page/) is particularly important if you're changing the URL scheme as you'll want visits to non-existent url's to be handled gracefully.

Create a 404.js file in the src/pages directory with the following content.

```javascript
import React from "react"
import { Link } from "gatsby"
import { Helmet } from "react-helmet"

class NotFoundPage extends React.Component {
  render() {

    return (
        <div>
        <Helmet title="404: Not Found" />
        <div>
          <h1>Not Found</h1>
          <p>
            The page you requested hasn't been found.
            </p>
            <p>
            <Link to={`/`}>
              Return home
            </Link>
          </p>
        </div>
      </div>
    )
  }
}

export default NotFoundPage

```

Next update your S3 bucket definition to point to your new 404 page.

```terraform
resource "aws_s3_bucket" "site_bucket" {
  bucket        = "${var.environment}.${var.domain_name_root}.${var.region}"
  acl           = "public-read"
  force_destroy = true
  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags {
    environment = "${var.environment}"
  }
}
```

## Add tags and categories pages

The code for tags and categories is very similar. What we'd like to end up with is two pages for each. The first will list all tags or categories and the second will list all of the posts within each tag or category.

### Landing Pages

See [here](https://github.com/awconstable/austenconstable.com/blob/master/src/pages/tags.js) for the tags landing page and [here](https://github.com/awconstable/austenconstable.com/blob/master/src/pages/category.js) for the categories landing page. Place in src/pages.

### Post Listings

The post listing per tag or category is slightly more complicated in that rather than a single page you need to dynamically create one page per tag or category. To do this we create a new page template (See [here](https://github.com/awconstable/austenconstable.com/blob/master/src/templates/tags.js) for tags and [here](https://github.com/awconstable/austenconstable.com/blob/master/src/templates/category.js) for categories) and then use that template in gatsby-node.js to generate a page per tag or category.
See my gatsby-node.js [here](https://github.com/awconstable/austenconstable.com/blob/master/gatsby-node.js).

## Migrate comments to Disqus

[Disqus](https://disqus.com/) provides an engaging and dynamic commentary service which integrates nicely with Gatsby and works around the problem of dynamic content on a static site. There are two parts to getting Disqus up and running. The first is to integrate Disqus with your site, the second is to import your existing comments from WordPress.

### Integrating Disqus with Gatsby

Install the gatsby-plugin-disqus plugin using npm

```bash
npm i --save-prod gatsby-plugin-disqus
```

Configure the plugin in your gatsby-config.js

```javascript
    {
      resolve: `gatsby-plugin-disqus`,
      options: {
        shortname: `austenconstable`
      }
    },
```

Next you need to update the post template to include the Disqus content. Copy over post.js to src/gatsby-theme-blog/components/post.js from the gatsby-theme-blog and add in a Disqus tag where you'd like the comments box to be displayed. See mine as an example [here](https://github.com/awconstable/austenconstable.com/blob/master/src/gatsby-theme-blog/components/post.js).

### Migrate existing comments

Disqus has WordPress import functionality which is well documented [here](https://help.disqus.com/en/articles/1717131-importing-comments-from-wordpress). Once you've imported the comments you'll need to update the url's the comments are associated with (assuming you have changed your url scheme). You may also need to use the domain migration tool if you changed your base url. In my case I chose to switch from www.austenconstable.com to austenconstable.com. See [here](https://help.disqus.com/en/articles/1717124-domain-migration-tool) for Disqus' Domain Migration Tool and [here](https://help.disqus.com/en/articles/1717129-url-mapper) for their URL mapper.

*Note: Disqus treats url's ending in / as different to those not ending in /. e.g. /post1/ != /post1*

## Added manifest and offline plugins for PWA compatibility

[Progressive Web Application](https://en.wikipedia.org/wiki/Progressive_web_application)'s enable rich installable web applications for mobile and desktop devices. Enabling PWA compatibility for the site allows it to be installed as an app on users mobile phones, which is pretty cool.

![Blog app installed on home screen](../images/2019/12/phone-screen.jpeg)

Install the gatsby-plugin-manifest and gatsby-plugin-offline plugins using npm

```bash
npm i --save-prod gatsby-plugin-manifest
npm i --save-prod gatsby-plugin-offline
```

Configure the plugin in your gatsby-config.js

```javascript
    {
      resolve: `gatsby-plugin-manifest`,
      options: {
        icon: `src/images/icon.jpeg`,
        name: `Austen Constable's Blog`,
        short_name: `Austen's Blog`,
        start_url: `/`,
        background_color: `#ffffff`,
        theme_color: `#037acc`,
        display: `standalone`,
      }
    },
    `gatsby-plugin-offline`,
```

## Added sitemap and robots.txt

To ensure search engines can easily traverse and index your site you'll need sitemap and robots files.

Install the gatsby-plugin-sitemap and gatsby-plugin-robots-txt plugins using npm

```bash
npm i --save-prod gatsby-plugin-sitemap
npm i --save-prod gatsby-plugin-robots-txt
```

Configure the plugins in your gatbys-config.js

```javascript
 {
      resolve: `gatsby-plugin-sitemap`,
      options: {}
    },
    {
      resolve: 'gatsby-plugin-robots-txt',
      options: {
        policy: [{ userAgent: '*', allow: '/' }]
      }
    },
```

## Other Minor Tweaks

* Switch external image links to use https.
* Switch my externally hosted Picasa images from thumbnails to fill the page
* Remove dead links from old posts
* Added Vagrant for a consistent build environment. See [here](https://github.com/awconstable/austenconstable.com/blob/master/Vagrantfile) if you're interested.
* Reviewed each post and resolved any formatting issues. Added headings, fixing code blocks etc.

## Deployment

Using the continuous deployment pipeline we built at the beginning of this post I've been following Lean principles and deploying each step to production as I've completed it. At this point everything is now working in production!

---

Wait for part three for remote updates via iOS.
