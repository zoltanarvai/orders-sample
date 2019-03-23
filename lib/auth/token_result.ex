defmodule Auth.TokenResult do
  @moduledoc """
  This struct represents the result of the authentication sign-in process.
  We get a JWT access token from Auth0 and an expires_in field explaining
  how long the token field will be available
  """
  @enforce_keys [:access_token, :expires_in]
  defstruct access_token: "", expires_in: 0

  @type t :: %__MODULE__{
          access_token: String.t(),
          expires_in: String.t()
        }
end
