defmodule Test.Auth.Credentials do
  use ExUnit.Case, async: true

  alias Auth.Credentials
  import Auth.Credentials

  @moduletag :unit

  test "validate/1 should return Auth.Credentials struct if payload is valid" do
    credentials = %Credentials{password: "UGFzc3dvcmQx", username: "user"}
    assert {:ok, ^credentials} = validate(%{username: "user", password: "UGFzc3dvcmQx"})
  end

  test "validate/1 should return error if password is missing" do
    {:error, %Ecto.Changeset{errors: errors, valid?: valid}} = validate(%{username: "user"})

    assert valid == false
    assert ^errors = [password: {"can't be blank", [validation: :required]}]
  end

  test "validate/1 should return error if password is in the wrong format" do
    {:error, %Ecto.Changeset{errors: errors, valid?: valid}} =
      validate(%{username: "user", password: "UGFzc3dvcmQxx"})

    assert valid == false
    assert ^errors = [password: {"Must be base64 encoded", []}]
  end

  test "validate/1 should return error if username is missing" do
    {:error, %Ecto.Changeset{errors: errors, valid?: valid}} =
      validate(%{password: "UGFzc3dvcmQx"})

    assert valid == false
    assert ^errors = [username: {"can't be blank", [validation: :required]}]
  end
end
