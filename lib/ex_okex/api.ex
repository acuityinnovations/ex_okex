defmodule ExOkex.Api do
  @moduledoc """
  Provides basic HTTP interface with API.
  """
  alias ExOkex.Config

  def get(path, params \\ %{}, config \\ nil) do
    config = Config.config_or_env_config(config)
    qs = query_string(path, params)

    qs
    |> url(config)
    |> HTTPoison.get(headers("GET", qs, %{}, config))
    |> parse_response()
  end

  def post(path, params \\ %{}, config \\ nil) do
    config = Config.config_or_env_config(config)

    path
    |> url(config)
    |> HTTPoison.post(Poison.encode!(params), headers("POST", path, params, config))
    |> parse_response()
  end

  def delete(path, config \\ nil) do
    config = Config.config_or_env_config(config)

    path
    |> url(config)
    |> HTTPoison.delete(headers("DELETE", path, %{}, config))
    |> parse_response()
  end

  defp url(path, config), do: config.api_url <> path

  defp query_string(path, params) when map_size(params) == 0, do: path

  defp query_string(path, params) do
    query =
      params
      |> Enum.map(fn {key, val} -> "#{key}=#{val}" end)
      |> Enum.join("&")

    path <> "?" <> query
  end

  defp headers(method, path, body, config) do
    timestamp =
      DateTime.utc_now()
      |> DateTime.truncate(:millisecond)
      |> DateTime.to_iso8601(:extended)

    [
      "Content-Type": "application/json",
      "OK-ACCESS-KEY": config.api_key,
      "OK-ACCESS-SIGN": sign_request(timestamp, method, path, body, config),
      "OK-ACCESS-TIMESTAMP": timestamp,
      "OK-ACCESS-PASSPHRASE": config.api_passphrase
    ]
  end

  defp sign_request(timestamp, method, path, body, config) do
    key = config.api_secret || ""
    body = if Enum.empty?(body), do: "", else: Poison.encode!(body)
    data = "#{timestamp}#{method}#{path}#{body}"

    :sha256
    |> :crypto.hmac(key, data)
    |> Base.encode64()
  end

  defp parse_response(response) do
    case response do
      {:ok, %HTTPoison.Response{body: body, status_code: code}} ->
        if code in 200..299 do
          {:ok, Poison.decode!(body)}
        else
          case Poison.decode(body) do
            {:ok, json} -> {:error, {json["code"], json["message"]}, code}
            {:error, _} -> {:error, body, code}
          end
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end