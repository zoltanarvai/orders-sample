defmodule Test.OrdersWeb.AuthView do
  use OrdersWeb.ConnCase, async: true

  import Phoenix.View

  @moduletag :unit

  @token_result %{
    access_token: "abc",
    expires_in: 86_400
  }

  test "renders show.json" do
    assert render(OrdersWeb.AuthView, "show.json", token_result: @token_result) == %{
             accessToken: @token_result.access_token,
             expiresIn: @token_result.expires_in
           }
  end
end
