defmodule Auth.Guardian.ErrorHandler do
  @moduledoc """
  This is a fallback module for Guardian errors. If pipeline fails, we'll fallback here.
  """
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  @doc false
  def auth_error(conn, {type, reason}, _opts) do
    body = to_string(type)

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, body)
  end
end
