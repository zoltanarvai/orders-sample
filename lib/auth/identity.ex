defmodule Auth.Identity do
  @moduledoc """
  This struct represents the Identitiy accessible on each connection
  """
  @enforce_keys [:id]
  defstruct id: nil

  @type t() :: [
          id: String.t()
        ]
end
