defmodule ExOkex.Swap.Public do
  import ExOkex.Api.Public

  @prefix "/api/swap/v3"

  def instruments do
    get("#{@prefix}/instruments", %{})
  end

  def price_limit(instrument_id) do
    get("#{@prefix}/instruments/#{instrument_id}/price_limit")
  end
end
