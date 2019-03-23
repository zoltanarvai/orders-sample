defmodule OrdersWeb.Router do
  use OrdersWeb, :router

  pipeline :public do
    plug :accepts, ["json"]
  end

  scope "/auth", OrdersWeb do
    pipe_through :public

    post "/sign-in", AuthController, :create
  end
end
