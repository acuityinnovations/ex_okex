defmodule ExOkex.Futures.MarginTest do
  use ExUnit.Case, async: true
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
end
