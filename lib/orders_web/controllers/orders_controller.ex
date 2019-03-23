defmodule OrdersWeb.OrdersController do
  @moduledoc """
  Management of orders
  """
  use OrdersWeb, :controller

  def index(conn, _) do
    conn
    |> put_status(:ok)
    |> render(:show, orders: "Here be orders")
  end
end
