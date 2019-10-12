module.exports = {
  plugins: [
    {
      resolve: `gatsby-theme-blog`,
      options: {},
    },
  ],
  // Customize your site metadata:
  siteMetadata: {
    title: `Austen's Travel Blog`,
    author: `Austen Constable`,
    description: `A blog recording some of my travel`,
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
