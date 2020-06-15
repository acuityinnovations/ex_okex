defmodule ExOkex.Margin.Public do
  @moduledoc false
  import ExOkex.Api.Public

  @spec get_best_ticker(String.t()) :: {:ok, map}
  def get_best_ticker(instrument) do
    get("/api/spot/v3/instruments/#{instrument}/ticker", %{}, nil)
  end
end
