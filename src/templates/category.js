import React from "react"
import PropTypes from "prop-types"
// Components
import { Styled } from "theme-ui"
import { Link, graphql } from "gatsby"
import Layout from "gatsby-theme-blog/src/components/layout"
import SEO from "gatsby-theme-blog/src/components/seo"

const Category = ({ pageContext, data, location }) => {
  const { category } = pageContext
  const { edges, totalCount } = data.allMdx
  const categoryHeader = `${totalCount} post${
    totalCount === 1 ? "" : "s"
  } categorised as "${category}"`
  return (
    <Layout location={location} title={data.site.siteMetadata.title}>
    <SEO title={`Posts in category "${category}"`} />
    <main>
      <Styled.h1>{categoryHeader}</Styled.h1>
      <ul>
        {edges.map(({ node }) => {
          const { slug } = node.frontmatter
          const { title } = node.frontmatter
          return (
            <li key={slug}>
              <Link to={slug}>{title}</Link>
            </li>
          )
        })}
      </ul>
      <Link to="/category">All categories</Link>
      </main>
    </Layout>
  )
}
Category.propTypes = {
  pageContext: PropTypes.shape({
    category: PropTypes.string.isRequired,
  }),
  data: PropTypes.shape({
    allMdx: PropTypes.shape({
      totalCount: PropTypes.number.isRequired,
      edges: PropTypes.arrayOf(
        PropTypes.shape({
          node: PropTypes.shape({
            frontmatter: PropTypes.shape({
              title: PropTypes.string.isRequired,
            }),
            fields: PropTypes.shape({
              slug: PropTypes.string.isRequired,
            }),
          }),
        }).isRequired
      ),
    }),
  }),
}
export default Category
export const pageQuery = graphql`
  query($category: String) {
    site {
      siteMetadata {
        title
      }
    }
    allMdx(
      limit: 2000
      sort: { fields: [frontmatter___date], order: DESC }
      filter: { frontmatter: { categories: { in: [$category] } } }
    ) {
      totalCount
      edges {
        node {
          frontmatter {
            title,
            slug
          }
        }
      }
    }
  }
`