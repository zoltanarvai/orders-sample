defmodule Auth.Credentials do
  @moduledoc """
  This module represents and validates the credentials
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Auth.Credentials

  @primary_key false
  embedded_schema do
    field :username, :string
    field :password, :string
  end

  @allowed_fields [:username, :password]
  @required_fields [:username, :password]

  @type t :: %__MODULE__{
          username: String.t(),
          password: String.t()
        }

  @doc """
  Validates the credentials object
  Returns: {:ok, %Credentials{}} | {:error, Ecto.Changeset.t(Credentials)}
  """
  @spec validate(map()) :: {:ok, Credentials.t()} | {:error, Ecto.Changeset.t(__MODULE__)}
  def validate(%{} = params \\ %{}) do
    %Credentials{}
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> validate_password()
    |> apply_action(:insert)
  end

  defp validate_password(changeset) do
    validate_change(changeset, :password, fn _field, password ->
      case Base.decode64(password, ignore: :whitespace) do
        {:ok, _decoded_password} ->
          []

        :error ->
          [password: "must be base64 encoded"]
      end
    end)
  end
end
