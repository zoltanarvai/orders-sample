defmodule OrdersWeb.AuthController do
  @moduledoc """
  This controller allows retrieving an access token from auth0 and returning it to the user
  providing username / password based login capability
  """
  use OrdersWeb, :controller

  alias Auth
  alias Auth.{Credentials, TokenResult}

  require Logger

  # Handles common errors, mainly authorisation and unexpected errors
  action_fallback OrdersWeb.FallbackController

  def create(conn, params) do
    _ = Logger.debug(fn -> "Login attempt with user: #{params["username"]}" end)

    with {:ok, credentials} <- Credentials.validate(params),
         {:ok, %TokenResult{} = result} <- Auth.sign_in(credentials) do
      conn
      |> put_status(:ok)
      |> render(:show, token_result: result)
    end
  end
end
