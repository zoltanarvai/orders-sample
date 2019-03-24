defmodule Test.Auth do
  use ExUnit.Case

  import Auth
  alias Auth.{Credentials, TokenResult}

  @moduletag :unit

  @auth0 Application.fetch_env!(:orders, :auth0)

  # Helper functions

  defp parse_body(conn) do
    conn |> Plug.Conn.read_body() |> elem(1) |> Jason.decode!(keys: :atoms)
  end

  defp auth0_request_fixture do
    %{
      grant_type: "password",
      username: "test@zoltanarvai.dev",
      password: "Password1",
      audience: @auth0.audience,
      scope: @auth0.scope,
      client_id: @auth0.client_id,
      client_secret: @auth0.client_secret
    }
  end

  # Test setup

  setup do
    bypass = Bypass.open(port: @auth0.url.port)

    {:ok, bypass: bypass}
  end

  # Test cases

  test "sign_in/1 returns TokenResult if Auth0 authentication was successful", %{bypass: bypass} do
    expected_response = %{
      access_token:
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL29yZGVycy1zYW1wbGUuZXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDVjOTYwNjhiMGQ4Y2VhMmVhOWUyNzMyZiIsImF1ZCI6Imh0dHBzOi8vb3JkZXJzLXNhbXBsZS1hcGkuem9sdGFuYXJ2YWkuZGV2LyIsImlhdCI6MTU1MzM0MjMxMiwiZXhwIjoxNTUzNDI4NzEyLCJhenAiOiI2TmVUM1ZIU3pLSzRtTVhWcTdCaFN2QXEwZlVTVVhVQiIsInNjb3BlIjoicmVhZDpvcmRlcnMiLCJndHkiOiJwYXNzd29yZCJ9.CbX3rLX6u4cvSyDHer0Kz_CXd8Bw2m5WKpD-jNSgrjI",
      token_type: "Bearer",
      expires_in: 86_400
    }

    Bypass.expect_once(bypass, "POST", "/oauth/token", fn conn ->
      assert parse_body(conn) == auth0_request_fixture()
      Plug.Conn.resp(conn, 200, expected_response |> Jason.encode!())
    end)

    {:ok, result} =
      sign_in(%Credentials{
        username: "test@zoltanarvai.dev",
        password: Base.encode64("Password1")
      })

    assert result == %TokenResult{
             access_token: expected_response.access_token,
             expires_in: expected_response.expires_in
           }
  end

  test "sign_in/1 returns {:error, :unauthorized} if Auth0 authentication fails with 401", %{
    bypass: bypass
  } do
    Bypass.expect_once(bypass, "POST", "/oauth/token", fn conn ->
      assert parse_body(conn) == auth0_request_fixture()
      Plug.Conn.resp(conn, 401, "Unauthorised")
    end)

    assert {:error, :unauthorized} ==
             sign_in(%Credentials{
               username: "test@zoltanarvai.dev",
               password: Base.encode64("Password1")
             })
  end

  test "sign_in/1 returns {:error, :forbidden} if Auth0 authentication fails with 403", %{
    bypass: bypass
  } do
    Bypass.expect_once(bypass, "POST", "/oauth/token", fn conn ->
      assert parse_body(conn) == auth0_request_fixture()
      Plug.Conn.resp(conn, 403, "Forbidden")
    end)

    assert {:error, :forbidden} ==
             sign_in(%Credentials{
               username: "test@zoltanarvai.dev",
               password: Base.encode64("Password1")
             })
  end

  test "sign_in/1 returns {:error, :unauthorized} if Auth0 authentication fails with 500", %{
    bypass: bypass
  } do
    Bypass.expect_once(bypass, "POST", "/oauth/token", fn conn ->
      assert parse_body(conn) == auth0_request_fixture()
      Plug.Conn.resp(conn, 500, "Internal Server Error")
    end)

    assert {:error, :unauthorized} ==
             sign_in(%Credentials{
               username: "test@zoltanarvai.dev",
               password: Base.encode64("Password1")
             })
  end

  test "sign_in/1 returns {:error, :unauthorized} if Auth0 connection is down", %{bypass: bypass} do
    bypass |> Bypass.down()

    assert {:error, :unauthorized} ==
             sign_in(%Credentials{
               username: "test@zoltanarvai.dev",
               password: Base.encode64("Password1")
             })
  end
end
