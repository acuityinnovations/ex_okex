defmodule ExOkex.Futures.MarginTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import TestHelper
  alias ExOkex.Margin.Private, as: Api

  describe "test place single order" do
    test "should return ok when place order success" do
      response =
        http_response(
          %{
            "client_oid" => "ecbe80ef8d3a4f29aaade5831ca91ce9",
            "error_code" => "0",
            "error_message" => "",
            "order_id" => "3422539729641472",
            "result" => true
          },
          201
        )

      config = %ExOkex.Config{
        api_key: "OKEX_API_KEY",
        api_secret: Base.encode64("OKEX_API_SECRET"),
        api_passphrase: "OKEX_API_PASSPHRASE"
      }

      with_mock_request(:post, response, fn ->
        order = %{
          client_oid: "y12233456",
          instrument_id: "BTC-USDT",
          margin_trading: "2",
          notional: "20",
          order_type: "0",
          side: "buy",
          type: "market"
        }

        assert Api.create_order(order, config) ==
                 {:ok,
                  %{
                    "client_oid" => "ecbe80ef8d3a4f29aaade5831ca91ce9",
                    "error_code" => "0",
                    "error_message" => "",
                    "order_id" => "3422539729641472",
                    "result" => true
                  }}
      end)
    end

    test "should return error when have error-param" do
      response =
        http_response(
          %{
            "client_oid" => "y12233456",
            "code" => "30024",
            "error_code" => "30024",
            "error_message" => "Parameter value filling error",
            "message" => "Parameter value filling error",
            "order_id" => "-1",
            "result" => false
          },
          200
        )

      config = %ExOkex.Config{
        api_key: "OKEX_API_KEY",
        api_secret: Base.encode64("OKEX_API_SECRET"),
        api_passphrase: "OKEX_API_PASSPHRASE"
      }

      with_mock_request(:post, response, fn ->
        order = %{
          client_oid: "y12233456",
          instrument_id: "BTC-USDT",
          margin_trading: "2",
          notional: "20",
          order_type: "0",
          side: "buy",
          type: "market"
        }

        assert Api.create_order(order, config) ==
                 {:ok,
                  %{
                    "client_oid" => "y12233456",
                    "error_code" => "30024",
                    "error_message" => "Parameter value filling error",
                    "order_id" => "-1",
                    "result" => false,
                    "code" => "30024",
                    "message" => "Parameter value filling error"
                  }}
      end)
    end

    test "should return error when don't have enough balance" do
      response =
        http_response(
          %{
            "client_oid" => "y12233456",
            "code" => "33017",
            "error_code" => "33017",
            "error_message" => "Greater than the maximum available balance",
            "message" => "Greater than the maximum available balance",
            "order_id" => "-1",
            "result" => false
          },
          200
        )

      config = %ExOkex.Config{
        api_key: "OKEX_API_KEY",
        api_secret: Base.encode64("OKEX_API_SECRET"),
        api_passphrase: "OKEX_API_PASSPHRASE"
      }

      with_mock_request(:post, response, fn ->
        order = %{
          client_oid: "y12233456",
          instrument_id: "BTC-USDT",
          margin_trading: "2",
          notional: "20",
          order_type: "0",
          side: "buy",
          type: "market"
        }

        assert Api.create_order(order, config) ==
                 {:ok,
                  %{
                    "client_oid" => "y12233456",
                    "order_id" => "-1",
                    "result" => false,
                    "code" => "33017",
                    "error_code" => "33017",
                    "error_message" => "Greater than the maximum available balance",
                    "message" => "Greater than the maximum available balance"
                  }}
      end)
    end
  end

  describe "test place multiple orders" do
    test "should return ok when place multiple orders successfully" do
      response =
        http_response(
          %{
            "btc-usdt" => [
              %{
                "client_oid" => "y12233456",
                "code" => "0",
                "error_code" => "0",
                "error_message" => "",
                "message" => "",
                "order_id" => "4890245706309632",
                "result" => true
              },
              %{
                "client_oid" => "y12233457",
                "code" => "0",
                "error_code" => "0",
                "error_message" => "",
                "message" => "",
                "order_id" => "4890245706440704",
                "result" => true
              }
            ]
          },
          201
        )

      config = %ExOkex.Config{
        api_key: "OKEX_API_KEY",
        api_secret: Base.encode64("OKEX_API_SECRET"),
        api_passphrase: "OKEX_API_PASSPHRASE"
      }

      with_mock_request(:post, response, fn ->
        orders = [
          %{
            client_oid: "y12233456",
            instrument_id: "BTC-USDT",
            margin_trading: "2",
            notional: "20",
            order_type: "0",
            side: "buy",
            type: "market"
          },
          %{
            client_oid: "y12233457",
            instrument_id: "BTC-USDT",
            margin_trading: "2",
            notional: "20",
            order_type: "0",
            side: "buy",
            type: "market"
          }
        ]

        assert Api.create_order(orders, config) ==
                 {:ok,
                  %{
                    "btc-usdt" => [
                      %{
                        "client_oid" => "y12233456",
                        "code" => "0",
                        "error_code" => "0",
                        "error_message" => "",
                        "message" => "",
                        "order_id" => "4890245706309632",
                        "result" => true
                      },
                      %{
                        "client_oid" => "y12233457",
                        "code" => "0",
                        "error_code" => "0",
                        "error_message" => "",
                        "message" => "",
                        "order_id" => "4890245706440704",
                        "result" => true
                      }
                    ]
                  }}
      end)
    end

    test "should return error if can not place multiple orders successfully" do
      response =
        http_response(
          %{
            "btc-usdt" => [
              %{
                "client_oid" => "y12233456",
                "code" => "33017",
                "error_code" => "33017",
                "error_message" => "Greater than the maximum available balance",
                "message" => "Greater than the maximum available balance",
                "order_id" => "-1",
                "result" => false
              },
              %{
                "client_oid" => "y12233457",
                "code" => "33017",
                "error_code" => "33017",
                "error_message" => "Greater than the maximum available balance",
                "message" => "Greater than the maximum available balance",
                "order_id" => "-1",
                "result" => false
              }
            ]
          },
          200
        )

      config = %ExOkex.Config{
        api_key: "OKEX_API_KEY",
        api_secret: Base.encode64("OKEX_API_SECRET"),
        api_passphrase: "OKEX_API_PASSPHRASE"
      }

      with_mock_request(:post, response, fn ->
        orders = [
          %{
            client_oid: "y12233456",
            instrument_id: "BTC-USDT",
            margin_trading: "2",
            notional: "20",
            order_type: "0",
            side: "buy",
            type: "market"
          },
          %{
            client_oid: "y12233457",
            instrument_id: "BTC-USDT",
            margin_trading: "2",
            notional: "20",
            order_type: "0",
            side: "buy",
            type: "market"
          }
        ]

        assert Api.create_order(orders, config) ==
                 {:ok,
                  %{
                    "btc-usdt" => [
                      %{
                        "client_oid" => "y12233456",
                        "code" => "33017",
                        "error_code" => "33017",
                        "error_message" => "Greater than the maximum available balance",
                        "message" => "Greater than the maximum available balance",
                        "order_id" => "-1",
                        "result" => false
                      },
                      %{
                        "client_oid" => "y12233457",
                        "code" => "33017",
                        "error_code" => "33017",
                        "error_message" => "Greater than the maximum available balance",
                        "message" => "Greater than the maximum available balance",
                        "order_id" => "-1",
                        "result" => false
                      }
                    ]
                  }}
      end)
    end
  end

  describe "get" do
    test "get all open orders" do
      use_cassette "margin/get_all_open_orders" do
        assert Api.get_open_orders("BTC-USDT") ==
                 {:ok,
                  [
                    %{
                      "client_oid" => "j12233457",
                      "created_at" => "2020-09-29T11:28:02.357Z",
                      "fee" => "",
                      "fee_currency" => "",
                      "filled_notional" => "0",
                      "filled_size" => "0",
                      "funds" => "",
                      "instrument_id" => "BTC-USDT",
                      "notional" => "",
                      "order_id" => "5678227938108416",
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
                      "timestamp" => "2020-09-29T11:28:02.357Z",
                      "type" => "limit"
                    }
                  ]}
      end
    end
  end

  describe "cancel" do
    test "cancel an order not found" do
      use_cassette "margin/cancel_a_not_found_order" do
        assert Api.cancel_order("BTC-USDT", %{client_oid: "a1234"}) ==
                 {:ok,
                  %{
                    "order_id" => "-1",
                    "result" => false,
                    "client_oid" => "a1234",
                    "code" => "33014",
                    "error_code" => "33014",
                    "error_message" => "Order does not exist",
                    "message" => "Order does not exist"
                  }}
      end
    end

    test "cancel an order" do
      use_cassette "margin/cancel_an_order" do
        assert Api.cancel_order("BTC-USDT", %{client_oid: "a12233457"}) ==
                 {:ok,
                  %{
                    "client_oid" => "a12233457",
                    "code" => "0",
                    "error_code" => "0",
                    "error_message" => "",
                    "message" => "",
                    "order_id" => "5678168753724416",
                    "result" => true
                  }}
      end
    end

    test "cancel multiple order" do
      use_cassette "margin/cancel_multiple_order" do
        assert Api.cancel_orders("BTC-USDT", ["5678198770328576"]) ==
                 {:ok,
                  %{
                    "btc-usdt" => [
                      %{
                        "client_oid" => "z12233457",
                        "code" => "0",
                        "error_code" => "0",
                        "error_message" => "",
                        "message" => "",
                        "order_id" => "5678198770328576",
                        "result" => true
                      }
                    ]
                  }}
      end
    end
  end
end
