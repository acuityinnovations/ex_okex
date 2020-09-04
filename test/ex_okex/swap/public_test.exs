defmodule ExOkex.Swap.PublicTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  import TestHelper

  alias ExOkex.Swap.Public, as: Api

  describe ".instruments" do
    test "returns the instruments" do
      instruments = [
        %{
          "instrument_id" => "BTC-USD-SWAP",
          "underlying_index" => "BTC",
          "quote_currency" => "USD",
          "tick_size" => "0.01",
          "contract_val" => "100",
          "listing" => "2019-03-08",
          "delivery" => "2019-03-22",
          "size_increment" => "1"
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
        "instrument_id" => "BTC-USD-SWAP",
        "highest" => "12190.28",
        "lowest" => "11496.13",
        "timestamp" => "2019-07-04T10:36:50.966Z"
      }

      response = http_response(current_price_limit, 200)

      with_mock_request(:get, response, fn ->
        assert {:ok, price_limit} = Api.price_limit("BTC-USD-SWAP")
        price_limit == current_price_limit
      end)
    end
  end

  describe "get" do
    test "best ticker" do
      use_cassette "swap/get_best_ticker" do
        assert Api.get_best_ticker("BTC-USD-SWAP") ==
                 {:ok,
                  %{
                    "best_ask" => "9063.2",
                    "best_ask_size" => "63",
                    "best_bid" => "9063.1",
                    "best_bid_size" => "722",
                    "high_24h" => "9440",
                    "instrument_id" => "BTC-USD-SWAP",
                    "last" => "9063.1",
                    "last_qty" => "2",
                    "low_24h" => "8891.2",
                    "timestamp" => "2020-06-15T07:40:17.399Z",
                    "volume_24h" => "4537698"
                  }}
      end
    end

    test "mark price" do
      use_cassette "swap/get_mark_price" do
        assert Api.get_mark_price("BTC-USD-SWAP") ==
          {:ok,
            %{
            "instrument_id" => "BTC-USD-SWAP",
            "mark_price" => "10261.4",
            "timestamp" => "2020-09-04T03:44:46.235Z"
            }}
      end
    end
  end
end
