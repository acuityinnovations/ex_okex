defmodule ExOkex.Futures.Private do
  @moduledoc """
  Futures account client.

  [API docs](https://www.okex.com/docs/en/#futures-README)
  """

  import ExOkex.Api.Private

  @type params :: map
  @type config :: map | nil
  @type response :: ExOkex.Api.response()

  @prefix "/api/futures/v3"

  @doc """
  Place a new order.

  ## Examples

  iex> ExOkex.Futures.create_order(%{
    client_oid: "y12233456",
    order_type: "1",
    instrument_id: "BTC-USD-180213",
    type: "1",
    price: "432.11",
    size: "2",
    match_price: "0",
    "leverage":"10"
  })

  {:ok, %{{
    "client_oid" => "y12233456",
    "error_code" => "0",
    "error_message" => "",
    "order_id" => "3422539729641472",
    "result" => true
  }}}
  """
  @spec create_order(params, config) :: response
  def create_order(params, config \\ nil) do
    post("#{@prefix}/order", params, config)
  end

  @doc """
  Place multiple orders for specific trading pairs (up to 4 trading pairs, maximum 4 orders each)

  https://www.okex.com/docs/en/#futures-batch

  ## Examples

  iex> ExOkex.Futures.create_bulk_orders([
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

  @doc """
  Cancelling an unfilled order.

  https://www.okex.com/docs/en/#futures-repeal

  ## Example

      iex> ExOkex.Futures.cancel_orders("BTC-USD-180309", [1600593327162368,1600593327162369])

      # TODO: Add response
  """
  def cancel_orders(instrument_id, order_ids \\ [], params \\ %{}, config \\ nil) do
    new_params = Map.merge(params, %{order_ids: order_ids})
    post("#{@prefix}/cancel_batch_orders/#{instrument_id}", new_params, config)
  end

  @doc """
  Get the futures account info of all token.

  https://www.okex.com/docs/en/#futures-singleness

  ## Examples

      iex(3)> ExOkex.Futures.list_accounts()

      # TODO: Add Response
  """
  def list_accounts(config \\ nil) do
    get("#{@prefix}/accounts", %{}, config)
  end

  @doc """
  Get the information of holding positions of a contract.

  https://www.okex.com/docs/en/#futures-hold_information

  ## Examples

      iex(3)> ExOkex.Futures.get_position("BTC-USD-190329")

  """
  def get_position(instrument_id, config \\ nil) do
    get("#{@prefix}/#{instrument_id}/position", %{}, config)
  end

  def get_positions(config \\ nil) do
    get("#{@prefix}/position", %{}, config)
  end

  @doc """
  Get the leverage of the futures account.

  https://www.okex.com/docs/en/#futures-huo-qu-he-yue-bi-zhong-gang-gan-bei-shu

  ## Examples

      iex(3)> ExOkex.Futures.Private.get_futures_leverage("BTC")

  """
  def get_futures_leverage(currency, config \\ nil) do
    get("#{@prefix}/accounts/#{currency}/leverage", %{}, config)
  end
end
