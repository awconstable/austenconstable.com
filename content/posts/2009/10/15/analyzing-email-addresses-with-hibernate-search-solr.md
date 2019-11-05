---
author: awconstable
comments: true
date: 2009-10-15 16:02:25+00:00
layout: post
link: http://austenconstable.com/?p=229
published: false
slug: 2009-10-15-analyzing-email-addresses-with-hibernate-search-solr
title: Analysing email addresses with Hibernate Search & Solr
wordpress_id: 229
categories:
- Java
tags:
- Hibernate
- Lucene
- Search
- Solr
---

On first appearance WordDelimiterFilterFactory seems like the most appropriate solution to the problem. It splits words into sub words on intra-word delimiters.

So:



	
  * "email@someserver.com" -> "email", "someserver", "com"


This works well except for the fact that it splits on _all_ intra-word delimiters, and when combined with the StandardAnalyzer splits on letter-number transitions.

So:



	
  * "email@some-server.com" -> "email", "some", "server", "com"

	
  * "email@server5.com" -> "email", "server", "5", "com"


Which is fine unless your users want to search for "server5" say or "some-server" (without analysing the search query itself).

And so the strategy I've taken is as follows,

	
  1. Use the PatternTokenizerFactory and split on "." and "@"

	
  2. Filter to lower case using LowerCaseFilterFactory

	
  3. Store the full email address in a separate field


Which now means that:

	
  * "email@some-server.com" -> "email", "some-server", "com"

	
  * "email@server5.com" -> "email", "server5", "com"


Searches for "server5" and "some-server" are now found.

There is naturally some room for improvement for example what if the user searches for "server" and "5", they would reasonably expect anything that matched "server5" to be returned. At the moment I'm handling this by allowing wildcard searches so "server*" does the trick. It may need revisiting, but only time will tell...

In case you're wondering how that gets put together here's a source snippet:

    
    @Entity
    @Indexed
    @Table(name = "user", catalog = "somedb")
    @AnalyzerDef(
      name = "email",
      tokenizer = @TokenizerDef(
        factory = PatternTokenizerFactory.class, params = {
          @Parameter(name = "pattern", value = ".|@")
        }),
        filters = {
          @TokenFilterDef(factory = LowerCaseFilterFactory.class)
        })
    public class User implements java.io.Serializable {
    ...
        @Column(name = "email", nullable = false, unique = true)
        @Fields( {
          @Field(name = "fullEmail", index = Index.UN_TOKENIZED, store = Store.YES),
          @Field(index = Index.TOKENIZED, analyzer = @Analyzer(definition = "email"), store = Store.YES)
        })
        public String getEmail() {
          return this.email;
        }
    ...
    }


Additional resources :

[http://wiki.apache.org/solr/AnalyzersTokenizersTokenFilters](http://wiki.apache.org/solr/AnalyzersTokenizersTokenFilters)
