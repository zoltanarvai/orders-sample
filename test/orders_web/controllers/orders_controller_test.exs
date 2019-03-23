defmodule Test.OrdersWeb.OrdersController do
  use OrdersWeb.ConnCase

  @moduletag :unit

  @auth0 Application.fetch_env!(:orders, :auth0)

  test "GET /orders should return successfully is token is valid", %{
    conn: conn
  } do
    # Bit more work is needed here, since this token will expire in 30 days, breaking the test
    # Easiest way is to issue our own tokens and turn off issuer validation for tests in Guardian
    # For demo purposes it's fine :)
    response =
      conn
      |> put_req_header("authorization", "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL29yZGVycy1zYW1wbGUuZXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDVjOTYwNjhiMGQ4Y2VhMmVhOWUyNzMyZiIsImF1ZCI6Imh0dHBzOi8vb3JkZXJzLXNhbXBsZS1hcGkuem9sdGFuYXJ2YWkuZGV2LyIsImlhdCI6MTU1MzM0OTMxNiwiZXhwIjoxNTU1OTQxMzE2LCJhenAiOiI2TmVUM1ZIU3pLSzRtTVhWcTdCaFN2QXEwZlVTVVhVQiIsInNjb3BlIjoicmVhZDpvcmRlcnMiLCJndHkiOiJwYXNzd29yZCJ9.RI5X5yVAR9wYoj2OvMSJEFJLbLaE3zFVqAF5bSyj8Zc")
      |> get("/orders")
      |> json_response(200)

    assert response == "Here be orders"
  end

  test "GET /orders should fail with 401 if token is not specified", %{
    conn: conn
  } do
    response =
      conn
      |> get("/orders")

      assert response.status == 401
  end

  test "GET /orders should fail with 401 if token is not valid", %{
    conn: conn
  } do
    response =
      conn
      |> put_req_header("authorization", "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL29yZGVycy1zYW1wbGUuZXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDVjOTYwNjhiMGQ4Y2VhMmVhOWUyNzMyZiIsImF1ZCI6Imh0dHBzOi8vb3JkZXJzLXNhbXBsZS1hcGkuem9sdGFuYXJ2YWkuZGV2LyIsImlhdCI6MTU1MzM0OTMxNiwiZXhwIjoxNTU1OTQxMzE2LCJhenAiOiI2TmVUM1ZIU3pLSzRtTVhWcTdCaFN2QXEwZlVTVVhVQiIsInNjb3BlIjoicmVhZDpvcmRlcnMiLCJndHkiOiJwYXNzd29yZCJ9.RI5X5yVAR9wYoj2OvMSJEFJLbLaE3zFVqAF5bSyj8Zsdfc")
      |> get("/orders")

    assert response.status == 401
  end
end