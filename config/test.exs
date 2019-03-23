use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :orders, OrdersWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :orders, Orders.Repo,
  username: "postgres",
  password: "postgres",
  database: "orders_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure Auth0 for the Auth module
config :orders,
auth0: %{
  url: %URI{
    host: "localhost",
    port: 3200,
    scheme: "http"
  },
  client_id: "6NeT3VHSzKK4mMXVq7BhSvAq0fUSUXUB",
  client_secret: "9aAIvTnSL-09QyP-ttbxy9l0NavpyySHulTMTqUYpyfTG0Clt8qz1IEAcqN5spy6",
  audience: "https://orders-sample-api.zoltanarvai.dev/",
  scope: "read:orders"
}