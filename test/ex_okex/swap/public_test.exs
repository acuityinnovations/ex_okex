defmodule ExOkex.Swap.PublicTest do
  use ExUnit.Case

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
end
