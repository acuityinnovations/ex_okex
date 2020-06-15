defmodule ExOkex.Spot.Public do
  @moduledoc false
  import ExOkex.Api.Public

  @prefix "/api/spot/v3"

  @spec get_best_ticker(String.t()) :: {:ok, map}
  def get_best_ticker(instrument) do
    get("#{@prefix}/instruments/#{instrument}/ticker", %{}, nil)
  end
end
