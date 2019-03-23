defmodule Auth do
  @moduledoc """
  This module is responsible to authenticate client credentials against Auth0
  and provide access_token and expires_in as a result
  """
  alias Auth.{Credentials, TokenResult}

  import Base

  require Logger

  @auth0 Application.fetch_env!(:orders, :auth0)

  @doc """
  Retrieves the access_token token for a username / password pair

  Returns {:ok, %TokenResult{access_token: 'ey...', expires_in: 86400}} or {:error, "reason"}

  ## Example:
      {:ok, result} = Auth.sign_in(%Credentials{username: "...", password: Base.encode64("...")})
  """
  @spec sign_in(Credentials.t()) :: {:ok, TokenResult.t()} | {:error, String.t()}
  def sign_in(%Credentials{username: username, password: encoded_password})
      when is_binary(username) and is_binary(encoded_password) do
    password = encoded_password |> decode64!(ignore: :whitespace)

    body = build_payload(username, password)
    headers = build_headers()

    @auth0.url
    |> build_url()
    |> HTTPoison.post(body, headers)
    |> IO.inspect
    |> response
    |> parse
  end

  defp build_url(%URI{} = url) do
    url |> Map.put(:path, "/oauth/token") |> URI.to_string()
  end

  defp build_headers, do: ["Content-type": "application/json"]

  defp build_payload(username, password) do
    %{
      grant_type: "password",
      username: username,
      password: password,
      audience: @auth0.audience,
      scope: @auth0.scope,
      client_id: @auth0.client_id,
      client_secret: @auth0.client_secret
    }
    # This is a predictable step, it cannot fail, error handling omitted intentionally
    |> Jason.encode!()
  end

  defp response({:ok, %{status_code: 200, body: body}}), do: {:ok, body}
  defp response({:ok, %{status_code: 401}}), do: {:error, :unauthorized}
  defp response({:ok, %{status_code: 403}}), do: {:error, :forbidden}

  defp response({:ok, %{status_code: status_code}}),
    do: {:error, "HTTP Status #{status_code} received"}

  defp response({:error, %{reason: reason}}), do: {:error, reason}

  defp parse({:ok, body}) do
    result =
      body
      |> Jason.decode!(keys: :atoms)
      |> Map.take([:access_token, :expires_in])

    {:ok, struct(TokenResult, result)}
  end

  defp parse({:error, :unauthorised}), do: {:error, :unauthorized}
  defp parse({:error, :forbidden}), do: {:error, :forbidden}

  defp parse({:error, error}) do
    _ = Logger.warn(fn -> "Failed to authenticate due to #{inspect(error)}" end)
    {:error, :unauthorized}
  end
end
