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

  https://www.okex.com/docs/en/#spot_leverage-orders

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
    post("#{@prefix}/orders", params, config)
  end

  @doc """
  Place multiple orders for specific trading pairs (up to 4 trading pairs, maximum 4 orders each)

  https://www.okex.com/docs/en/#spot_leverage-batch

  ## Examples

  iex> ExOkex.Margin.Private.create_bulk_orders(
      [%{
          client_oid: "a12233457",
          instrument_id: "BTC-USDT",
          margin_trading: "2",
          size: "0.001",
          order_type: "0",
          side: "sell",
          type: "limit",
          order_type: "0",
          price: "11000"
      }],
    nil)

    {:ok,
     %{
       "btc-usdt" => [
         %{
           "client_oid" => "a12233457",
           "code" => "0",
           "error_code" => "0",
           "error_message" => "",
           "message" => "",
           "order_id" => "5672427477614592",
           "result" => true
         }
       ]
     }}
  """
  @spec create_bulk_orders(params, config) :: response
  def create_bulk_orders(params, config \\ nil) do
    post("#{@prefix}/batch_orders", params, config)
  end

  @doc """
  Get all open orders
  {:ok,
   [
     %{
       "client_oid" => "y12233456",
       "created_at" => "2020-09-28T09:25:47.812Z",
       "fee" => "",
       "fee_currency" => "",
       "filled_notional" => "0",
       "filled_size" => "0",
       "funds" => "",
       "instrument_id" => "BTC-USDT",
       "notional" => "",
       "order_id" => "5672084951031808",
       "order_type" => "0",
       "price" => "11000",
       "price_avg" => "0",
       "product_id" => "BTC-USDT",
       "rebate" => "",
       "rebate_currency" => "",
       "side" => "sell",
       "size" => "0.001",
       "state" => "0",
       "status" => "open",
       "timestamp" => "2020-09-28T09:25:47.812Z",
       "type" => "limit"
     }
   ]}
  """
  def get_open_orders(instrument_id, config \\ nil) do
    params = %{instrument_id: instrument_id}
    get("#{@prefix}/orders_pending", params, config)
  end

  @doc """
  Cancel an order
  ExOkex.Margin.Private.cancel_order("BTC-USDT", %{client_oid: "y12233456"})
  {:ok,
   %{
     "client_oid" => "y12233456",
     "code" => "0",
     "error_code" => "0",
     "error_message" => "",
     "message" => "",
     "order_id" => "5672084951031808",
     "result" => true
   }}
  """
  @spec cancel_order(any, any, config) :: response
  def cancel_order(instrument_id, params, config \\ nil) do
    case Map.take(params, [:client_oid, :order_id]) do
      %{client_oid: client_oid} ->
        post(
          "#{@prefix}/cancel_orders/#{client_oid}",
          %{instrument_id: instrument_id},
          config
        )

      %{order_id: order_id} ->
        post(
          "#{@prefix}/cancel_orders/#{order_id}",
          %{instrument_id: instrument_id},
          config
        )

      _ ->
        {:error, "invalid params"}
    end
  end

  @doc """
  Cancel multiple orders
  ## Examples
  iex> ExOkex.Margin.Private.cancel_orders("btc-usdt", ["5672262084612096"])
    {:ok,
      %{
      "btc-usdt" => [
        %{
           "client_oid" => "a12233457",
           "code" => "0",
           "error_code" => "0",
           "error_message" => "",
           "message" => "",
           "order_id" => "5672262084612096",
           "result" => true
        }
      ]
    }}
  """
  def cancel_orders(instrument_id, order_ids \\ [], params \\ %{}, config \\ nil) do
    new_params = Map.merge(params, %{order_ids: order_ids, instrument_id: instrument_id})
    post("#{@prefix}/cancel_batch_orders", [new_params], config)
  end

  defdelegate create_batch_orders(params, config \\ nil), to: __MODULE__, as: :create_bulk_orders
end
