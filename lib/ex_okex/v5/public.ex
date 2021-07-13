defmodule ExOkex.V5.Public do
  @moduledoc false
  import ExOkex.Api.Public

  @prefix "/api/v5"

  @doc """
  Retrieve a list of instruments with open contracts.

  https://www.okex.com/docs-v5/en/#rest-api-public-data-get-instruments

  iex> ExOkex.V5.Public.get_instruments(%{"instType" => "SPOT"})
  iex> {:ok,
         %{
           "code" => "0",
           "data" => [
             %{
               "alias" => "",
               "baseCcy" => "BTC",
               "category" => "1",
               "ctMult" => "",
               "ctType" => "",
               "ctVal" => "",
               "ctValCcy" => "",
               "expTime" => "",
               "instId" => "BTC-USDT",
               "instType" => "SPOT",
               "lever" => "10",
               "listTime" => "1548133413000",
               "lotSz" => "0.00000001",
               "minSz" => "0.00001",
               "optType" => "",
               "quoteCcy" => "USDT",
               "settleCcy" => "",
               "state" => "live",
               "stk" => "",
               "tickSz" => "0.1",
               "uly" => ""
             },
             ...
            ]
          }
        }
  """
  def get_instruments(params \\ %{}) do
    get("#{@prefix}/public/instruments", params, nil)
  end

  @doc """
  Retrieve the latest price snapshot, best bid/ask price, and trading volume in the last 24 hours.

  https://www.okex.com/docs-v5/en/#rest-api-market-data-get-ticker

  iex> ExOkex.V5.Public.get_ticker(%{instId: "BTC-USD-SWAP"})
  iex> {:ok,
         %{
           "code" => "0",
           "data" => [
             %{
               "askPx" => "33874.8",
               "askSz" => "1490",
               "bidPx" => "33874.7",
               "bidSz" => "451",
               "high24h" => "34143.2",
               "instId" => "BTC-USD-SWAP",
               "instType" => "SWAP",
               "last" => "33874.7",
               "lastSz" => "0",
               "low24h" => "33000",
               "open24h" => "33396.4",
               "sodUtc0" => "33514",
               "sodUtc8" => "33961",
               "ts" => "1626027243020",
               "vol24h" => "4888685",
               "volCcy24h" => "14523.566"
             }
           ],
           "msg" => ""
         }}
  """
  def get_ticker(params \\ %{}) do
    get("#{@prefix}/market/ticker", params, nil)
  end

  @doc """
  Retrieve index tickers.

  https://www.okex.com/docs-v5/en/#rest-api-market-data-get-index-tickers

  iex> ExOkex.V5.Public.get_index_price(%{instId: "BTC-USD"})
  iex> {:ok,
         %{
           "code" => "0",
           "data" => [
             %{
               "high24h" => "34108.71",
               "idxPx" => "33916.68",
               "instId" => "BTC-USD",
               "low24h" => "33040.14",
               "open24h" => "33446.08",
               "sodUtc0" => "33519.36",
               "sodUtc8" => "33953.7",
               "ts" => "1626027715930"
             }
           ],
           "msg" => ""
         }}
  """
  def get_index_price(params) do
    get("#{@prefix}/market/index-tickers", params, nil)
  end

  @doc """
  Retrieve mark price.

  https://www.okex.com/docs-v5/en/#rest-api-public-data-get-mark-price

  iex> ExOkex.V5.Public.get_mark_price(%{instType: "MARGIN", instId: "BTC-USDT"})
  iex> {:ok,
         %{
           "code" => "0",
           "data" => [
             %{
               "instId" => "BTC-USDT",
               "instType" => "MARGIN",
               "markPx" => "33894.1708242113195196",
               "ts" => "1626027921409"
             }
           ],
           "msg" => ""
         }}
  """
  def get_mark_price(params) do
    get("#{@prefix}/public/mark-price", params, nil)
  end

  @doc """
  Retrieve the highest buy limit and lowest sell limit of the instrument.

  https://www.okex.com/docs-v5/en/#rest-api-public-data-get-limit-price

  iex> ExOkex.V5.Public.get_price_limit(%{instId: "BTC-USD-SWAP"})
  iex> {:ok,
         %{
           "code" => "0",
           "data" => [
             %{
               "buyLmt" => "34578.9",
               "instId" => "BTC-USD-SWAP",
               "instType" => "SWAP",
               "sellLmt" => "33222.6",
               "ts" => "1626028085198"
             }
           ],
           "msg" => ""
         }}
  """
  def get_price_limit(params) do
    get("#{@prefix}/public/price-limit", params, nil)
  end
end
