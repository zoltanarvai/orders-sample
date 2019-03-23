defmodule OrdersWeb.Router do
  use OrdersWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", OrdersWeb do
    pipe_through :api
  end
end
