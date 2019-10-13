module.exports = {
  plugins: [
    {
      resolve: `gatsby-theme-blog`,
      options: {},
    },
  ],
  // Customize your site metadata:
  siteMetadata: {
    title: `Austen's Blog`,
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
