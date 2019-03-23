defmodule OrdersWeb.Router do
  use OrdersWeb, :router

  pipeline :public do
    plug :accepts, ["json"]
  end

  # Pipeline for private apis, requires Authorisation header with Bearer token
  pipeline :private do
    plug :accepts, ["json"]

    plug Auth.Guardian.Pipeline
  end

  scope "/auth", OrdersWeb do
    pipe_through :public

    post "/sign-in", AuthController, :create
  end

  scope "/orders", OrdersWeb do
    pipe_through :private

    get "/", OrdersController, :index
  end
end
