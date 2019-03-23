defmodule Auth.Guardian.Pipeline do
  @moduledoc """
  Configures a set of plugs to be used with Guardian based authentication / authorisation
  """
  use Guardian.Plug.Pipeline,
    otp_app: :orders,
    error_handler: Auth.Guardian.ErrorHandler,
    module: Auth.Guardian

  # Verify authorisation header and make sure order management is allowed for Identity
  plug Guardian.Plug.VerifyHeader

  # Make sure the token is found and authenticated
  plug Guardian.Plug.EnsureAuthenticated

  # Load the Identity
  plug Guardian.Plug.LoadResource

  # Add :current_identity to the connection
  plug :assign_current_identity

  defp assign_current_identity(conn, _) do
    conn
    |> assign(:current_identity, Guardian.Plug.current_resource(conn))
  end
end
