defmodule ExOkex.Auth do
  @moduledoc false
  @spec timestamp :: String.t()
  def timestamp do
    time = :os.system_time(:millisecond) / 1000

    time
    |> Float.to_string()
  end

  @spec sign(String.t(), String.t(), String.t(), map | [map], String.t()) :: String.t()
  def sign(timestamp, method, path, body, api_secret) do
    body = if Enum.empty?(body), do: "", else: Jason.encode!(body)
    data = "#{timestamp}#{method}#{path}#{body}"

    :sha256
    |> :crypto.hmac(api_secret, data)
    |> Base.encode64()
  end
end
