package hello

import org.scalatra._

class MyScalatraServlet extends HelloScalatraStack {

  get("/") {
    <html>
      <body>
        <h1>Hello, world!</h1>
        Say <a href="hello-scalate">hello to Scalate</a>.
      </body>
    </html>
  }

  get("/hello/:name") {
    val name = params("name")
    s"Hello, $name!"
  }
}
