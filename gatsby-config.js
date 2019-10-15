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
    }
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
