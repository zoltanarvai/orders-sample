defmodule Orders.Repo do
  use Ecto.Repo,
    otp_app: :orders,
    adapter: Ecto.Adapters.Postgres
end
