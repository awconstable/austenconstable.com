---
author: awconstable
comments: true
date: 2009-03-13 14:49:05+00:00
layout: post
link: http://austenconstable.com/?p=193
published: false
slug: howto-remove-gwt-package-from-url-when-using-gwt-maven
title: 'HOWTO: Remove GWT package from url when using gwt-maven'
wordpress_id: 193
categories:
- HOWTO
- Java
tags:
- GWT
- maven
---

Seriously, who wants a url like /my.long.package.name.Application/Application.html

To remedy this use the following steps:



	
  1. Make the webapp directory the same as the output for your gwt code.

    
     
    ...
    
    	org.apache.maven.plugins
    	maven-war-plugin
    
    		${project.build.directory}/${project.build.finalName}/my.long.package.name.Application	
    
    ...




	
  2. Ensure that your rpc servlets don't have the package as a prefix.

    
     
    ...
    
    	com.totsp.gwt
    	maven-googlewebtoolkit2-plugin
    	...
    
    		...
    		true
    
    	...
    
    ...




	
  3. Change your index.html file to point to your app.
From:



To:





	
  4. Your done.


Additional resources:
[http://groups.google.com/group/Google-Web-Toolkit/browse_thread/thread/f8b06676098b8cc6](http://groups.google.com/group/Google-Web-Toolkit/browse_thread/thread/f8b06676098b8cc6)

[http://groups.google.com/group/gwt-maven/browse_thread/thread/a46f540ca823e3d3/7d5febf0776958db?lnk=gst&q=rename#7d5febf0776958db](http://groups.google.com/group/gwt-maven/browse_thread/thread/a46f540ca823e3d3/7d5febf0776958db?lnk=gst&q=rename#7d5febf0776958db)
