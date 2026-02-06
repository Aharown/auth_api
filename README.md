# AUTHENTICATION API

This API receives JSON requests to sign up, log in, and retrieve authenticated user information.

Users are persisted in a PostgreSQL database using Rails’ ActiveRecord ORM. Passwords are securely hashed using bcrypt.

Authentication is handled using stateless JSON Web Tokens (JWT). Upon successful login, the API issues a signed JWT containing the user’s ID and an expiration claim. This token must be included in the Authorization header of subsequent requests to access protected endpoints.

Each request is authenticated by validating and decoding the JWT, allowing the API to identify the current user without storing session data on the server.

---

### How Authentication Works
Authentication is handled using stateless JSON Web Tokens (JWT). When a user successfully logs in, the server issues a signed JWT containing the user’s ID and an expiration claim. The token is signed using a secret key, which allows the server to verify the token’s authenticity and detect any tampering.

The JWT is returned to the client in a JSON response and is valid for 24 hours. For subsequent requests to protected endpoints, the client includes the token in the `Authorization` header using the `Bearer` scheme.

On each request, the server extracts and decodes the JWT using a dedicated decoder service. If the token is valid and unexpired, the associated user is identified and the request is authorized. If the token is missing, invalid, or expired, the server responds with a 401 Unauthorized error.

---

### Why JWTs vs sessions
JWTs are used instead of sessions to enable stateless authentication. With sessions, the server must store and manage session data for each authenticated user, whereas JWTs allow the client to prove its identity on each request by presenting a signed token.

This approach reduces server-side state, simplifies horizontal scaling, and is well-suited for JSON-based APIs consumed by multiple types of clients such as SPAs, mobile apps, and third-party services.

JWTs are better suited for scalability and flexibility, which makes them a good fit for API-driven systems.

---

## Tech Stack
- Ruby on Rails
- PostgreSQL
- JWT Authentication

## Setup
```bash
bundle install
rails db:create db:migrate
rails s
