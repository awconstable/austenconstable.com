import React from "react"
import { Link } from "gatsby"
import { Helmet } from "react-helmet"

class NotFoundPage extends React.Component {
  render() {

    return (
        <div>
        <Helmet title="404: Not Found" />
        <div>
          <h1>Not Found</h1>
          <p>
            The page you requested hasn't been found.
            </p>
            <p>
            <Link to={`/`}>
              Return home
            </Link>
          </p>
        </div>
      </div>
    )
  }
}

export default NotFoundPage
