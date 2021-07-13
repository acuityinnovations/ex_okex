defmodule ExOkex.V5.Private do
  import ExOkex.Api.Private

  @prefix "/api/v5"

  @doc """
  Place a new order.

  https://www.okex.com/docs-v5/en/#rest-api-trade-place-order

  iex> ExOkex.V5.Private.create_order(
        %{
          instId: "BTC-USDT",
          tdMode: "cash",
          clOrdId: "0f831d77ca9b4aa58b9cab0ce09f4e21",
          side: "buy",
          ordType: "limit",
          sz: "0.0001",
          px: "33000"
        },
        config
      )

  iex> {:ok,
         %{
           "code" => "0",
           "data" => [
             %{
               "clOrdId" => "0f831d77ca9b4aa58b9cab0ce09f4e21",
               "ordId" => "334524758649888768",
               "sCode" => "0",
               "sMsg" => "",
               "tag" => ""
             }
           ],
           "msg" => ""
         }}
  """
  def create_order(params, config \\ nil) do
    post("#{@prefix}/trade/order", params, config)
  end

  # ExOkex.V5.Private.create_order(
  #   %{
  #     instId: "BTC-USDT",
  #     tdMode: "cash",
  #     clOrdId: "0f831d77ca9b4aa58b9cab0ce09f4e21",
  #     side: "buy",
  #     ordType: "limit",
  #     sz: "0.0001",
  #     px: "33000"
  #   },
  #   config
  # )

  @doc """
  Place orders in batches

  https://www.okex.com/docs-v5/en/#rest-api-trade-place-multiple-orders

  iex> ExOkex.V5.Private.create_bulk_orders(
        [
          %{
            instId: "BTC-USDT",
            tdMode: "cash",
            clOrdId: "0f831aa7ca9b4aa58b9cab0ce09f4e21",
            side: "buy",
            ordType: "limit",
            sz: "0.0001",
            px: "33000"
          },
          %{
            instId: "BTC-USDT",
            tdMode: "cash",
            clOrdId: "0f831bb7ca9b4aa58b9cab0ce09f4e21",
            side: "buy",
            ordType: "limit",
            sz: "0.0001",
            px: "33500"
          }
        ],
        config
      )

  iex> {:ok,
         %{
           "code" => "0",
           "data" => [
             %{
               "clOrdId" => "0f831aa7ca9b4aa58b9cab0ce09f4e21",
               "ordId" => "334533313809506304",
               "sCode" => "0",
               "sMsg" => "",
               "tag" => ""
             },
             %{
               "clOrdId" => "0f831bb7ca9b4aa58b9cab0ce09f4e21",
               "ordId" => "334533313809506305",
               "sCode" => "0",
               "sMsg" => "",
               "tag" => ""
             }
           ],
           "msg" => ""
         }}
  """
  def create_bulk_orders(params, config \\ nil) do
    post("#{@prefix}/trade/batch-orders", params, config)
  end

  defdelegate create_batch_orders(params, config \\ nil), to: __MODULE__, as: :create_bulk_orders

  @doc """
  Amend an order

  https://www.okex.com/docs-v5/en/#rest-api-trade-amend-order

  iex> 
  """
  def update_order(params, config \\ nil) do
    post("#{@prefix}/trade/amend-order", params, config)
  end

  @doc """
  Amend multiple orders

  https://www.okex.com/docs-v5/en/#rest-api-trade-amend-multiple-orders

  iex> 
  """
  def update_orders(params, config \\ nil) do
    post("#{@prefix}/amend-batch-orders", params, config)
  end

  @doc """
  Retrieve a list of assets (with non-zero balance), remaining balance, and available amount in the account.

  https://www.okex.com/docs-v5/en/#rest-api-account-get-account-and-position-risk

  iex(1)> ExOkex.V5.Private.get_balance(%{ccy: "USDT"}, config)
    {:ok,
     %{
       "available" => "0.005",
       "balance" => "0.005",
       "currency" => "btc",
       "frozen" => "0",
       "hold" => "0",
       "holds" => "0",
       "id" => "2006057"
     }}
  """
  def get_balance(params, config \\ nil) do
    get("#{@prefix}/account/balance", params, config)
  end

  @doc """
  Cancelling an unfilled order.

  https://www.okex.com/docs/en/#spot-revocation

  ## Example

  iex> ExOkex.V5.Private.cancel_order(
        %{
          instId: "BTC-USDT",
          clOrdId: "0f831d77ca9b4aa58b9cab0ce09f4e21"
        },
        config
      )

  iex> {:ok,
         %{
           "code" => "0",
           "data" => [
             %{
               "clOrdId" => "0f831d77ca9b4aa58b9cab0ce09f4e21",
               "ordId" => "334524758649888768",
               "sCode" => "0",
               "sMsg" => ""
             }
           ],
           "msg" => ""
         }}
  """
  def cancel_order(params \\ %{}, config \\ nil) do
    post("#{@prefix}/trade/cancel-order", params, config)
  end

  def cancel_orders(params \\ %{}, config \\ nil) do
    post("#{@prefix}/trade/cancel-batch-orders", params, config)
  end

  # ExOkex.V5.Private.cancel_orders([%{instId: "BTC-USDT-SWAP", ordId: "ordId"}])

  @doc """
  Retrieve information on your positions.
  When the account is in net mode, net positions will be displayed, and when
  the account is in long/short mode, long or short positions will be displayed.

  https://www.okex.com/docs-v5/en/#rest-api-account-get-positions

  iex> ExOkex.V5.Private.get_positions(%{instType: "SWAP", instId: "BTC-USDT-SWAP"}, config)

  iex> {:ok,
         %{
           "code" => "0",
           "data" => [
             %{
               "liab" => "",
               "optVal" => "",
               "pos" => "1",
               "gammaPA" => "",
               "upl" => "-0.0437339428057749",
               "vegaBS" => "",
               "mmr" => "1.323845064228777",
               "uplRatio" => "-0.0013212471958357",
               "posSide" => "long",
               "instId" => "BTC-USDT-SWAP",
               "availPos" => "1",
               "mgnRatio" => "22.195793786455834",
               "liqPx" => "29925.21300853842",
               "adl" => "5",
               "interest" => "0",
               "deltaPA" => "",
               "imr" => "",
               "lever" => "10",
               "mgnMode" => "isolated",
               "liabCcy" => "",
               "tradeId" => "95532236",
               "avgPx" => "33100.5",
               "uTime" => "1626111227381",
               "instType" => "SWAP",
               "posId" => "334869990763552771",
               "posCcy" => "",
               "gammaBS" => "",
               "notionalUsd" => "330.91493147994623",
               "margin" => "33.1005",
               "vegaPA" => "",
               "deltaBS" => "",
               "thetaBS" => "",
               "ccy" => "USDT",
               "thetaPA" => "",
               "cTime" => "1626111227381",
               "last" => "33095.1"
             }
           ],
           "msg" => ""
         }}
  """
  def get_positions(params, config \\ nil) do
    get("#{@prefix}/account/positions", params, config)
  end

  @doc """
  Get leverage

  iex> ExOkex.V5.Private.get_leverage(%{instId: "BTC-USDT-SWAP", mgnMode: "cross"}, config)
  iex> {:ok,
         %{
           "code" => "0",
           "data" => [
             %{
               "instId" => "BTC-USDT-SWAP",
               "lever" => "10",
               "mgnMode" => "cross",
               "posSide" => "long"
             },
             %{
               "instId" => "BTC-USDT-SWAP",
               "lever" => "10",
               "mgnMode" => "cross",
               "posSide" => "short"
             }
           ],
           "msg" => ""
         }}
  """
  def get_leverage(params, config \\ nil) do
    get("#{@prefix}/account/leverage-info", params, config)
  end

  @doc """

  """
  def update_leverage(params, config \\ nil) do
    post("#{@prefix}/account/set-leverage", params, config)
  end

  @doc """
  Retrieve all incomplete orders under the current account.

  https://www.okex.com/docs-v5/en/#rest-api-trade-get-order-list

  iex> ExOkex.V5.Private.get_open_orders(%{instId: "BTC-USDT-SWAP"}, config)

  iex> {:ok,
         %{
           "code" => "0",
           "data" => [
             %{
               "accFillSz" => "0",
               "avgPx" => "",
               "cTime" => "1626111712105",
               "category" => "normal",
               "ccy" => "",
               "clOrdId" => "",
               "fee" => "0",
               "feeCcy" => "USDT",
               "fillPx" => "",
               "fillSz" => "0",
               "fillTime" => "",
               "instId" => "BTC-USDT-SWAP",
               "instType" => "SWAP",
               "lever" => "10",
               "ordId" => "334872023843364866",
               "ordType" => "limit",
               "pnl" => "0",
               "posSide" => "long",
               "px" => "32000",
               "rebate" => "0",
               "rebateCcy" => "USDT",
               "side" => "buy",
               "slOrdPx" => "",
               "slTriggerPx" => "",
               "state" => "live",
               "sz" => "1",
               "tag" => "",
               "tdMode" => "isolated",
               "tpOrdPx" => "",
               "tpTriggerPx" => "",
               "tradeId" => "",
               "uTime" => "1626111712105"
             }
           ],
           "msg" => ""
         }}
  """
  def get_open_orders(params, config \\ nil) do
    get("#{@prefix}/trade/orders-pending", params, config)
  end
end
