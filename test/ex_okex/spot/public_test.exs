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
  end
end
