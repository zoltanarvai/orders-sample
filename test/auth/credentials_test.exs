defmodule Test.Auth.Credentials do
  use ExUnit.Case, async: true
  use Orders.DataCase

  alias Auth.Credentials
  import Auth.Credentials

  @moduletag :unit

  test "validate/1 should return Auth.Credentials struct if payload is valid" do
    credentials = %Credentials{password: "UGFzc3dvcmQx", username: "user"}
    assert {:ok, ^credentials} = validate(%{username: "user", password: "UGFzc3dvcmQx"})
  end

  test "validate/1 should return error if password is missing" do
    {:error, changeset} = validate(%{username: "user"})

    refute changeset.valid?
    assert %{password: ["can't be blank"]} = errors_on(changeset)
  end

  test "validate/1 should return error if password is in the wrong format" do
    {:error, changeset} = validate(%{username: "user", password: "UGFzc3dvcmQxx"})

    refute changeset.valid?
    assert %{password: ["must be base64 encoded"]} = errors_on(changeset)
  end

  test "validate/1 should return error if username is missing" do
    {:error, changeset} = validate(%{password: "UGFzc3dvcmQx"})

    refute changeset.valid?
    assert %{username: ["can't be blank"]} = errors_on(changeset)
  end
end
