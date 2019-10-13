---
author: awconstable
comments: true
date: 2009-03-13 10:21:30+00:00
layout: post
link: http://austenconstable.com/?p=186
published: false
slug: howto-run-your-java-web-app-as-the-root-context-on-tomcat
title: 'HOWTO: Run your java web app as the root context on Tomcat'
wordpress_id: 186
categories:
- HOWTO
- Java
tags:
- maven
- Tomcat
---

If you have a context XML fragment in your war (`META-INF/context.xml`) then it's as easy as renaming your war file to `ROOT.war`

If you're using the maven build system then just alter your pom to have:

    
    
    	ROOT
    	...


Simple when you know how...
