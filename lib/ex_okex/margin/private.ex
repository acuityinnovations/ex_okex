defmodule ExOkex.Margin.Private do
    @moduledoc """
    Futures account client.
  
    [API docs](https://www.okex.com/docs/en/#spot-line)
    """
  
    import ExOkex.Api.Private
  
    @type params :: map
    @type config :: map | nil
    @type response :: ExOkex.Api.response()
  
    @prefix "/api/margin/v3"
  
    @doc """
    Place a new order.
  
    ## Examples
  
    iex> ExOkex.Margin.Private.create_order(
        %{
            client_oid: "y12233456",
            instrument_id: "BTC-USDT",
            margin_trading: "2",
            notional: "20",
            order_type: "0",
            side: "buy",
            type: "market"
        }, config)
  
    {:ok, %{
        "client_oid" => "y12233456",
        "code" => "0",
        "error_code" => "0",
        "error_message" => "",
        "message" => "",
        "order_id" => "4889392870415360",
        "result" => true
    }}
    """
    @spec create_order(params, config) :: response
    def create_order(params, config \\ nil) do
      post("#{@prefix}/orders   ", params, config)
    end
  
    @doc """
    Place multiple orders for specific trading pairs (up to 4 trading pairs, maximum 4 orders each)
  
    https://www.okex.com/docs/en/#futures-batch
  
    ## Examples
  
    iex> ExOkex.Margin.Private.create_bulk_orders([
      %{"instrument_id":"BTC-USD-180213",
        "type":"1",
        "price":"432.11",
        "size":"2",
        "match_price":"0",
        "leverage":"10" },
      ])
  
      # TODO: Add response sample
  
    """
    @spec create_bulk_orders(params, config) :: response
    def create_bulk_orders(params, config \\ nil) do
      post("#{@prefix}/orders", params, config)
    end
  
    defdelegate create_batch_orders(params, config \\ nil), to: __MODULE__, as: :create_bulk_orders
  end