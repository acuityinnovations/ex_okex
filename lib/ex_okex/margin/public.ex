defmodule ExOkex.Margin.Public do
  @moduledoc false
  import ExOkex.Api.Public

  @spec get_best_ticker(String.t()) :: {:ok, map}
  def get_best_ticker(instrument) do
    get("/api/spot/v3/instruments/#{instrument}/ticker", %{}, nil)
  end

  def get_exchange_info() do
    get("/api/spot/v3/instruments", %{}, nil)
  end

  @spec get_mark_price(String.t()) :: {:ok, map}
  def get_mark_price(instrument) do
    get("/api/margin/v3/instruments/#{instrument}/mark_price", %{}, nil)
  end
end
