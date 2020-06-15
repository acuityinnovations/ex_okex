defmodule ExOkex.Futures.PublicTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  import TestHelper

  alias ExOkex.Futures.Public, as: Api

  describe ".instruments" do
    test "returns the instruments" do
      instruments = [
        %{
          "instrument_id" => "BTC-USD-190322",
          "underlying_index" => "BTC",
          "quote_currency" => "USD",
          "tick_size" => "0.01",
          "contract_val" => "100",
          "listing" => "2019-03-08",
          "delivery" => "2019-03-22",
          "trade_increment" => "1",
          "alias" => "this_week"
        }
      ]

      response = http_response(instruments, 200)

      with_mock_request(:get, response, fn ->
        assert {:ok, returned_instruments} = Api.instruments()
        assert returned_instruments == instruments
      end)
    end
  end

  describe ".instrument" do
    test "returns the price limit" do
      current_price_limit = %{
        "instrument_id" => "BTC-USD-190927",
        "highest" => "12190.28",
        "lowest" => "11496.13",
        "timestamp" => "2019-07-04T10:36:50.966Z"
      }

      response = http_response(current_price_limit, 200)

      with_mock_request(:get, response, fn ->
        assert {:ok, price_limit} = Api.price_limit("BTC-USD-190927")
        price_limit == current_price_limit
      end)
    end
  end

  describe "get" do
    test "best ticker" do
      use_cassette "futures/get_best_ticker" do
        assert Api.get_best_ticker("BTC-USD-200619") ==
                 {:ok,
                  %{
                    "best_ask" => "9060.49",
                    "best_ask_size" => "2",
                    "best_bid" => "9060.34",
                    "best_bid_size" => "45",
                    "high_24h" => "9452.83",
                    "instrument_id" => "BTC-USD-200619",
                    "last" => "9060.95",
                    "last_qty" => "48",
                    "low_24h" => "8898.44",
                    "timestamp" => "2020-06-15T07:29:36.768Z",
                    "volume_24h" => "1641044"
                  }}
      end
    end
  end
end
