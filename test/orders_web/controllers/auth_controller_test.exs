defmodule Test.OrdersWeb.AuthController do
  use OrdersWeb.ConnCase

  import Test.Support.Bypass

  @moduletag :unit

  @auth0 Application.fetch_env!(:orders, :auth0)

  setup do
    bypass = Bypass.open(port: @auth0.url.port)

    {:ok, bypass: bypass}
  end

  test "POST /auth/sign-in should successfully log the user in when credentials are valid", %{
    bypass: bypass,
    conn: conn
  } do
    expected_response = %{
      access_token:
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL29ya2VzdHJvLmV1LmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw1YzdkM2E2MzZkM2Q3MzJlNmFhOTY0YWEiLCJhdWQiOiJodHRwczovL29yZGVycy5vcmtlc3Ryby5jb20iLCJpYXQiOjE1NTI0MDM1MTksImV4cCI6MTU1MjQ4OTkxOSwiYXpwIjoia25rSjQ1QUpnM1VSaEt3YXRQRW1ZRERxeWN1bFo0Y2wiLCJzY29wZSI6Im1hbmFnZTpvcmRlcnMiLCJndHkiOiJwYXNzd29yZCJ9.08o060XyZZhwg0wTz3z9JjHhpdjdO6pEILy6f369ez4",
      token_type: "Bearer",
      expires_in: 86_400
    }

    # Setup mock calls
    expect_auth_token_call(bypass, expected_response)

    response =
      conn
      |> put_req_header("accept", "application/json")
      |> post("/auth/sign-in",
        username: "test@zoltanarvai.dev",
        password: Base.encode64("Password1")
      )
      |> json_response(200)

    assert response == %{
             "accessToken" => expected_response.access_token,
             "expiresIn" => expected_response.expires_in
           }
  end

  test "POST /auth/sign-in should return 400 when payload is not valid", %{conn: conn} do
    response =
      conn
      |> put_req_header("accept", "application/json")
      |> post("/auth/sign-in", username: "test@zoltanarvai.dev")
      |> json_response(400)

    assert response == %{"errors" => %{"password" => ["can't be blank"]}}
  end

  test "POST /auth/sign-in should return 401 when authentication has failed", %{
    bypass: bypass,
    conn: conn
  } do
    # Setup mock calls
    expect_auth_token_call(bypass, 401, "Unauthorised")

    response =
      conn
      |> put_req_header("accept", "application/json")
      |> post("/auth/sign-in",
        username: "test@zoltanarvai.dev",
        password: Base.encode64("Password1")
      )
      |> json_response(401)

    assert response == %{"errors" => %{"detail" => "Unauthorized"}}
  end

  test "POST /auth/sign-in should return 401 when Auth0 is down", %{
    bypass: bypass,
    conn: conn
  } do
    # Setup mock calls
    expect_auth_token_call(bypass, 500, "Internal Server Error")

    response =
      conn
      |> put_req_header("accept", "application/json")
      |> post("/auth/sign-in",
        username: "test@zoltanarvai.dev",
        password: Base.encode64("Password1")
      )
      |> json_response(401)

    assert response == %{"errors" => %{"detail" => "Unauthorized"}}
  end
end
