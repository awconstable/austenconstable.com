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
        name: `Austen Constable's Travel Blog`,
        short_name: `Austen's Travel Blog`,
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
              const siteUrl = site.siteMetadata.siteUrl;
              
                let html = edge.node.html;
                // Hacky workaround for https://github.com/gaearon/overreacted.io/issues/65
                html = html
                  .replace(/href="\//g, `href="${siteUrl}/`)
                  .replace(/src="\//g, `src="${siteUrl}/`)
                  .replace(/"\.\.\/images\//g, `"${siteUrl}/images/`);
                  
                return Object.assign({}, edge.node.frontmatter, {
                  description: edge.node.excerpt,
                  date: edge.node.frontmatter.date,
                  url: site.siteMetadata.siteUrl + '/' + edge.node.frontmatter.slug,
                  guid: site.siteMetadata.siteUrl + '/' + edge.node.frontmatter.slug,
                  custom_elements: [{ 'content:encoded': html }]
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
            title: "Austen's Travel Blog",
          }
        ]
      }
    },
    {
      resolve: `gatsby-plugin-canonical-urls`,
      options: {
        siteUrl: `https://austenconstable.com`,
      },
    },
  ],
  // Customize your site metadata:
  siteMetadata: {
    title: `Austen's Travel Blog`,
    siteUrl: `https://austenconstable.com`,
    author: `Austen Constable`,
    description: `A travel blog`,
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
