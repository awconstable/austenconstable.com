---
author: awconstable
comments: true
date: 2008-11-26 16:17:16+00:00
layout: post
link: http://austenconstable.com/?p=180
published: false
slug: howto-setup-a-shell-java-struts-2-web-app-using-maven-2-eclipse-34
title: 'HOWTO: Setup a shell Java Struts 2 web app using Maven 2 & Eclipse 3.4'
wordpress_id: 180
categories:
- HOWTO
- Java
tags:
- eclipse
- maven
- struts2
---

The latest project I'm working on is a Java web app using Struts 2. I wanted to use the eclipse IDE since it's industry standard and the Maven 2 build system for compatibility with other company projects.

I did plenty of reading ([Maven: The Definitive Guide](http://books.sonatype.com/maven-book/) is a good place to start), but nowhere did I find an easy step-by-step quickstart for this combination of tools.

So I've pieced my reading and research together and here it is:


### Prerequisites


Java
maven 2
eclipse 3.4.1


### Create a new skeleton project:



    
    cd ~/workspace/
    mvn archetype:generate -DgroupId={name of your group e.g. com.austenconstable} 
    -DartifactId={name of your app} 
    -DarchetypeGroupId=org.apache.struts 
    -DarchetypeArtifactId=struts2-archetype-starter 
    -DarchetypeVersion=2.0.11.2


If you're not sure on the latest struts 2 archetype release version check [here](http://repo1.maven.org/maven2/org/apache/struts/struts2-archetype-starter/).


### Generate the eclipse project files:



    
    mvn eclipse:eclipse




### Configure eclipse:



    
    mvn eclipse:configure-workspace -Declipse.workspace=/path/to/your/workspace/




### Import the project into eclipse:


Fire up eclipse and use File>Import...

And now all you need to do is build your app!
