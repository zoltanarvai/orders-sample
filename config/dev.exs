use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :orders, OrdersWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Configure your database
config :orders, Orders.Repo,
  username: "postgres",
  password: "postgres",
  database: "orders_dev",
  hostname: "localhost",
  pool_size: 10

# Configure Auth0 for the Auth module
config :orders,
  auth0: %{
    url: %URI{
      host: "orders-sample.eu.auth0.com",
      port: 443,
      scheme: "https"
    },
    client_id: "6NeT3VHSzKK4mMXVq7BhSvAq0fUSUXUB",
    client_secret: "9aAIvTnSL-09QyP-ttbxy9l0NavpyySHulTMTqUYpyfTG0Clt8qz1IEAcqN5spy6",
    audience: "https://orders-sample-api.zoltanarvai.dev/",
    scope: "read:orders"
  }

# Setup Guardian with Auth0
config :orders, Auth.Guardian,
  allowed_algos: ["HS256"],
  verify_module: Guardian.JWT,
  issuer: "https://orders-sample.eu.auth0.com/",
  verify_issuer: true,
  secret_key: "qgXw5waJYQ8kd6LDFpqY4UuswJ4D0gGS"
