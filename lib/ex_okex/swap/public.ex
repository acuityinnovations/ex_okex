defmodule ExOkex.Swap.Public do
  @moduledoc false

  import ExOkex.Api.Public

  @prefix "/api/swap/v3"

  def instruments do
    get("#{@prefix}/instruments", %{})
  end

  def price_limit(instrument_id) do
    get("#{@prefix}/instruments/#{instrument_id}/price_limit")
  end

  def get_best_ticker(instrument) do
    get("#{@prefix}/instruments/#{instrument}/ticker")
  end
end
