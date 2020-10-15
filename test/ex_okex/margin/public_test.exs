defmodule ExOkex.Margin.PublicTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExOkex.Margin.Public, as: Api

  describe "get" do
    test "best ticker" do
      use_cassette "margin/get_best_ticker" do
        assert Api.get_best_ticker("BTC-USDT") ==
                 {:ok,
                  %{
                    "best_ask" => "9095.5",
                    "best_ask_size" => "0.37588793",
                    "best_bid" => "9095.4",
                    "best_bid_size" => "6.17920015",
                    "high_24h" => "9447.5",
                    "instrument_id" => "BTC-USDT",
                    "last" => "9095.4",
                    "last_qty" => "0.05167106",
                    "low_24h" => "8910.4",
                    "timestamp" => "2020-06-15T07:37:27.940Z",
                    "ask" => "9095.5",
                    "base_volume_24h" => "54252.83721147",
                    "bid" => "9095.4",
                    "open_24h" => "9407.6",
                    "product_id" => "BTC-USDT",
                    "quote_volume_24h" => "503609901.6"
                  }}
      end
    end

    test "mark price" do
      use_cassette "margin/get_mark_price" do
        assert Api.get_mark_price("BTC-USDT") ==
                 {:ok,
                  %{
                    "instrument_id" => "BTC-USDT",
                    "mark_price" => "9153.2",
                    "timestamp" => "2020-07-18T08:59:56.778Z"
                  }}
      end
    end

    test "exchange info" do
      use_cassette "margin/get_exchange_info" do
        assert {:ok,
                [
                  %{
                    "base_currency" => "XPO",
                    "category" => "3",
                    "instrument_id" => "XPO-USDT",
                    "min_size" => "1",
                    "quote_currency" => "USDT",
                    "size_increment" => "0.0001",
                    "tick_size" => "0.00001"
                  }
                  | _
                ]} = Api.get_exchange_info()
      end
    end
  end
end
