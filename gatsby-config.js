module.exports = {
  plugins: [
    {
      resolve: `gatsby-theme-blog`,
      options: {}
    },
    {
      resolve: `gatsby-plugin-google-analytics`,
      options: {
        trackingId: "UA-451873-2"
      }
    },
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
    {
      resolve: `gatsby-plugin-disqus`,
      options: {
        shortname: `austenconstable`
      }
    },
    {
      resolve: `gatsby-plugin-feed`,
      options: {
        query: `
          {
            site {
              siteMetadata {
                title
                description
                siteUrl
                site_url: siteUrl
              }
            }
          }
        `,
        feeds: [
          {
            serialize: ({ query: { site, allMdx } }) => {
              return allMdx.edges.map(edge => {
                return Object.assign({}, edge.node.frontmatter, {
                  description: edge.node.excerpt,
                  date: edge.node.frontmatter.date,
                  url: site.siteMetadata.siteUrl + '/' + edge.node.frontmatter.slug,
                  guid: site.siteMetadata.siteUrl + '/' + edge.node.frontmatter.slug,
                  custom_elements: [{ 'content:encoded': edge.node.html }]
                })
              })
            },
            query: `
              {
                allMdx(
                  sort: { order: DESC, fields: [frontmatter___date, frontmatter___title] },
                  limit: 10,
                ) {
                  edges {
                    node {
                      excerpt
                      html
                      frontmatter {
                        title
                        date
                        slug
                      }
                    }
                  }
                }
              }
            `,
            output: '/rss.xml',
            title: "Austen's Blog",
          }
        ]
      }
    },
  ],
  // Customize your site metadata:
  siteMetadata: {
    title: `Austen's Blog`,
    siteUrl: `https://austenconstable.com`,
    author: `Austen Constable`,
    description: `A blog of travel, linux and coding`,
    social: [
      {
        name: `twitter`,
        url: `https://twitter.com/austenconstable`,
      },
      {
        name: `github`,
        url: `https://github.com/awconstable`,
      },
    ],
  },
}
