defmodule OrdersWeb.OrdersView do
  @moduledoc """
  Provides Data View for Orders
  """
  use OrdersWeb, :view

  def render("show.json", %{orders: orders}) do
    orders
  end
end
