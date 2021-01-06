defmodule ExOkex.Spot.PublicTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExOkex.Spot.Public, as: Api

  describe "get" do
    test "best ticker" do
      use_cassette "spot/get_best_ticker" do
        assert Api.get_best_ticker("BTC-USDT") ==
                 {:ok,
                  %{
                    "best_ask" => "9078.1",
                    "best_ask_size" => "0.21613862",
                    "best_bid" => "9078",
                    "best_bid_size" => "10.91752656",
                    "high_24h" => "9447.5",
                    "instrument_id" => "BTC-USDT",
                    "last" => "9080.9",
                    "last_qty" => "0.01888099",
                    "low_24h" => "8910.4",
                    "timestamp" => "2020-06-15T07:44:47.702Z",
                    "ask" => "9078.1",
                    "base_volume_24h" => "54321.22096763",
                    "bid" => "9078",
                    "open_24h" => "9400.2",
                    "product_id" => "BTC-USDT",
                    "quote_volume_24h" => "504179165.6"
                  }}
      end
    end

    test "get index price" do
      use_cassette "spot/get_index_price" do
        assert Api.get_index_price("ADA-BTC") ==
                 {:ok,
                  %{
                    "code" => 0,
                    "data" => %{
                      "constituents" => [
                        %{
                          "exchange" => "OKEx",
                          "original_price" => "0.00000807",
                          "symbol" => "ADA/BTC",
                          "usd_price" => "0.00000807",
                          "weight" => "0.167"
                        },
                        %{
                          "exchange" => "Huobi",
                          "original_price" => "0.00000808",
                          "symbol" => "ADA/BTC",
                          "usd_price" => "0.00000808",
                          "weight" => "0.167"
                        },
                        %{
                          "exchange" => "Binance",
                          "original_price" => "0.00000806",
                          "symbol" => "ADA/BTC",
                          "usd_price" => "0.00000806",
                          "weight" => "0.167"
                        },
                        %{
                          "exchange" => "OKEx_INDEX",
                          "original_price" => "0.27616",
                          "symbol" => "ADA/USDT",
                          "usd_price" => "0.0000080562631495",
                          "weight" => "0.500"
                        }
                      ],
                      "instrument_id" => "ADA-BTC",
                      "last" => "0.0000080631384363",
                      "timestamp" => "2021-01-06T10:19:48.442Z"
                    },
                    "detailMsg" => "",
                    "error_code" => "0",
                    "error_message" => "",
                    "msg" => ""
                  }}
      end
    end
  end
end
