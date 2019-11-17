---
date: 2019-11-17
layout: post
slug: 2019-11-17-grade-on-steroids
title: Gradle on steroids
categories:
- Code
tags:
- Maven
- Gradle
- build tools
- CI/CD
---

I’ve been experimenting with the [Gradle](https://gradle.org/) build tool and the final hurdle, while converting one of my [Maven](https://maven.apache.org/) projects, was to produce a tagged release.

For simple projects I’m a big fan of Axel Fontaine’s [“Maven on Steroids”](https://axelfontaine.com/blog/maven-releases-steroids-2.html) pattern. Whilst Gradle has a number of release and version plugins (<https://github.com/researchgate/gradle-release>, <https://github.com/ru-fix/gradle-release-plugin>, <https://github.com/allegro/axion-release-plugin>, <https://github.com/nebula-plugins/nebula-release-plugin>), they are all quite heavyweight and I couldn’t find one that enabled this simple versioning approach. After lots of Googling and some experimentation, the following seems to work quite well.

## Configure your gradle build

### Step 1: Create a version.gradle file

In the project's root directory create a version.gradle file and populate with 0-SNAPSHOT.
0-SNAPSHOT will be the default version number and is used for local snapshot builds. We'll override this during the CI build process.

```groovy
// ${rootDir}/version.gradle
project.version = "0-SNAPSHOT"
```

Then plug the new version file into your Gradle build like so:

```groovy
// ${rootDir}/build.gradle
allprojects {
    apply from: "${rootDir}/version.gradle"
}
```

### Step 2: Setup your CI build to update your projects version

I'm using [CircleCI](https://circleci.com/) for this particular project, so I've added a task to re-version the build with the appropriate version number - in this case, taken from the tag.

```bash
      - run:
          name: If we're building a tag, set the version to that of the tag
          command: |
            if [ -n "$CIRCLE_TAG" ]; \
            then \
              sed -i -e "s/0-SNAPSHOT/$CIRCLE_TAG/g" version.gradle; \
            fi
```

### And we're done

Using this approach we have a really lightweight way to version releases which doesn't resort to the lengthy workflow of the [Maven release plugin](https://maven.apache.org/maven-release/maven-release-plugin/).

## References

* <https://stackoverflow.com/questions/42044160/gradle-equivalent-of-maven-versions-plugin>
* <https://axelfontaine.com/blog/maven-releases-steroids.html>
