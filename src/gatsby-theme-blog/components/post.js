import React from "react"
import { Styled, css } from "theme-ui"

import PostFooter from "gatsby-theme-blog/src/components/post-footer"
import Layout from "gatsby-theme-blog/src/components/layout"
import SEO from "gatsby-theme-blog/src/components/seo"
import { MDXRenderer } from "gatsby-plugin-mdx"

import { Disqus, CommentCount } from "gatsby-plugin-disqus"

const Post = ({
  data: {
    post,
    site: {
      siteMetadata: { title, siteUrl },
    },
  },
  location,
  previous,
  next,
  disqusConfig = {
    url: `${siteUrl+location.pathname}`,
    identifier: post.id,
    title: post.title,
  }
}) => (
  <Layout location={location} title={title}>
    <SEO title={post.title} description={post.excerpt} />
    <main>
      <Styled.h1>{post.title}</Styled.h1>
      <CommentCount config={disqusConfig} placeholder={'...'} />
      <Styled.p
        css={css({
          fontSize: 1,
          mt: -3,
          mb: 3,
        })}
      >
        {post.date}
      </Styled.p>
      <MDXRenderer>{post.body}</MDXRenderer>
      <Disqus config={disqusConfig} />
    </main>
    <PostFooter {...{ previous, next }} />
  </Layout>
)

export default Post
