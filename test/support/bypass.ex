defmodule Test.Support.Bypass do
  @moduledoc false

  def expect_auth_token_call(bypass, auth_response) do
    Bypass.expect_once(bypass, "POST", "/oauth/token", fn conn ->
      Plug.Conn.resp(conn, 200, Jason.encode!(auth_response))
    end)
  end

  def expect_auth_token_call(bypass, status, auth_response) do
    Bypass.expect_once(bypass, "POST", "/oauth/token", fn conn ->
      Plug.Conn.resp(conn, status, auth_response)
    end)
  end
end
