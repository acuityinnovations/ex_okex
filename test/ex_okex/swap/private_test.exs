defmodule ExOkex.Swap.PrivateTest do
  use ExUnit.Case
  import TestHelper
  alias ExOkex.Swap.Private, as: Api

  describe ".create_order" do
    test "returns placed order" do
      response = http_response(%{"price" => "1.00"}, 201)

      with_mock_request(:post, response, fn ->
        assert {:ok, %{"price" => "1.00"}} =
                 Api.create_order(%{side: "buy", product_id: "ETH-USD", price: "1.00"})
      end)
    end
  end

  describe ".update_order" do
    test "returns updated order" do
      response =
        http_response(
          %{
            "client_oid" => "q122334579",
            "error_code" => "0",
            "error_message" => "",
            "order_id" => "",
            "request_id" => "",
            "result" => "true"
          },
          200
        )

      with_mock_request(:post, response, fn ->
        assert {:ok, %{"client_oid" => "q122334579", "error_code" => "0"}} =
                 Api.update_order(%{
                   instrument_id: "BTC-USD-SWAP",
                   client_oid: "q122334579",
                   new_price: "16000"
                 })
      end)
    end
  end

  describe ".remove_order by order_id" do
    test "returns placed order" do
      response =
        http_response(
          %{
            "error_code" => "0",
            "error_message" => "",
            "order_id" => "465688276882628608",
            "client_oid" => "oktswap6",
            "result" => "true"
          },
          200
        )

      with_mock_request(:post, response, fn ->
        assert {:ok, %{"order_id" => "465688276882628608"}} =
                 Api.cancel_order("BTC-USD-SWAP", %{order_id: "465688276882628608"})
      end)
    end
  end

  describe ".remove_order by client_oid" do
    test "returns placed order" do
      response =
        http_response(
          %{
            "error_code" => "0",
            "error_message" => "",
            "order_id" => "465688276882628608",
            "client_oid" => "oktswap6",
            "result" => "true"
          },
          200
        )

      with_mock_request(:post, response, fn ->
        assert {:ok, %{"client_oid" => "oktswap6"}} =
                 Api.cancel_order("BTC-USD-SWAP", %{client_oid: "oktswap6"})
      end)
    end
  end

  describe ".list_accounts" do
    test "returns list of accounts" do
      response = http_response([%{"balance" => "0.00"}], 200)

      with_mock_request(:get, response, fn ->
        assert {:ok, [%{"balance" => "0.00"}]} == Api.list_accounts()
      end)
    end

    test "accepts dynamically specified config" do
      config = %ExOkex.Config{
        api_key: "OKEX_API_KEY",
        api_secret: Base.encode64("OKEX_API_SECRET"),
        api_passphrase: "OKEX_API_PASSPHRASE"
      }

      response = http_response([%{"balance" => "0.00"}], 200)

      with_mock_request(:get, response, fn ->
        assert {:ok, [%{"balance" => "0.00"}]} == Api.list_accounts(config)
      end)
    end
  end

  describe ".get_position" do
    test "returns position info" do
      config = %ExOkex.Config{
        api_key: "OKEX_API_KEY",
        api_secret: Base.encode64("OKEX_API_SECRET"),
        api_passphrase: "OKEX_API_PASSPHRASE"
      }

      response =
        http_response(
          [
            %{
              "created_at" => "2019-02-12T15:10:04.000Z",
              "instrument_id" => "BTC-USD-190329",
              "leverage" => "20",
              "liquidation_price" => "0.0",
              "long_avail_qty" => "0",
              "long_avg_cost" => "3870.5",
              "long_qty" => "0",
              "long_settlement_price" => "3870.5",
              "margin_mode" => "crossed",
              "realised_pnl" => "-0.00011875",
              "short_avail_qty" => "0",
              "short_avg_cost" => "3863",
              "short_qty" => "0",
              "short_settlement_price" => "3863",
              "updated_at" => "2019-03-10T07:19:14.000Z"
            }
          ],
          200
        )

      with_mock_request(:get, response, fn ->
        assert {:ok,
                [
                  %{
                    "leverage" => "20",
                    "created_at" => "2019-02-12T15:10:04.000Z",
                    "instrument_id" => "BTC-USD-190329",
                    "liquidation_price" => "0.0",
                    "long_avail_qty" => "0",
                    "long_avg_cost" => "3870.5",
                    "long_qty" => "0",
                    "long_settlement_price" => "3870.5",
                    "margin_mode" => "crossed",
                    "realised_pnl" => "-0.00011875",
                    "short_avail_qty" => "0",
                    "short_avg_cost" => "3863",
                    "short_qty" => "0",
                    "short_settlement_price" => "3863",
                    "updated_at" => "2019-03-10T07:19:14.000Z"
                  }
                ]} == Api.get_position("BTC-USD-190329", config)
      end)
    end
  end

  describe ".get_positions" do
    test "returns position info" do
      config = %ExOkex.Config{
        api_key: "OKEX_API_KEY",
        api_secret: Base.encode64("OKEX_API_SECRET"),
        api_passphrase: "OKEX_API_PASSPHRASE"
      }

      response =
        http_response(
          [
            %{
              "holding" => [
                %{
                  "avail_position" => "1",
                  "avg_cost" => "7802.6",
                  "instrument_id" => "BTC-USD-SWAP",
                  "last" => "7802.6",
                  "leverage" => "10.00",
                  "liquidation_price" => "0.0",
                  "maint_margin_ratio" => "0.0050",
                  "margin" => "0.0012",
                  "position" => "1",
                  "realized_pnl" => "-0.0001",
                  "settled_pnl" => "0.0000",
                  "settlement_price" => "7802.6",
                  "side" => "short",
                  "timestamp" => "2020-01-10T03:49:54.585Z",
                  "unrealized_pnl" => "-0.0001"
                }
              ],
              "margin_mode" => "crossed",
              "timestamp" => "2020-01-10T03:49:54.585Z"
            }
          ],
          200
        )

      with_mock_request(:get, response, fn ->
        assert {:ok,
                [
                  %{
                    "holding" => [
                      %{
                        "avail_position" => "1",
                        "avg_cost" => "7802.6",
                        "instrument_id" => "BTC-USD-SWAP",
                        "last" => "7802.6",
                        "leverage" => "10.00",
                        "liquidation_price" => "0.0",
                        "maint_margin_ratio" => "0.0050",
                        "margin" => "0.0012",
                        "position" => "1",
                        "realized_pnl" => "-0.0001",
                        "settled_pnl" => "0.0000",
                        "settlement_price" => "7802.6",
                        "side" => "short",
                        "timestamp" => "2020-01-10T03:49:54.585Z",
                        "unrealized_pnl" => "-0.0001"
                      }
                    ],
                    "margin_mode" => "crossed",
                    "timestamp" => "2020-01-10T03:49:54.585Z"
                  }
                ]} == Api.get_positions(config)
      end)
    end
  end

  describe ".get_swap_leverage" do
    test "returns leverage of the swap account" do
      config = %ExOkex.Config{
        api_key: "OKEX_API_KEY",
        api_secret: Base.encode64("OKEX_API_SECRET"),
        api_passphrase: "OKEX_API_PASSPHRASE"
      }

      response =
        http_response(
          %{
            "long_leverage" => "5.0000",
            "short_leverage" => "5.0000",
            "margin_mode" => "crossed",
            "instrument_id" => "BTC-USD-SWAP"
          },
          200
        )

      with_mock_request(:get, response, fn ->
        assert {:ok,
                %{
                  "long_leverage" => "5.0000",
                  "short_leverage" => "5.0000",
                  "margin_mode" => "crossed",
                  "instrument_id" => "BTC-USD-SWAP"
                }} == Api.get_leverage("BTC-USD-SWAP", config)
      end)
    end
  end

  describe ".get_open_orders" do
    test "should return error if instrument is incorrect" do
      config = %ExOkex.Config{
        api_key: "OKEX_API_KEY",
        api_secret: Base.encode64("OKEX_API_SECRET"),
        api_passphrase: "OKEX_API_PASSPHRASE"
      }

      response =
        http_response(%{error_code: 35001, error_message: "Contract does not exist"}, 400)

      with_mock_request(:get, response, fn ->
        assert Api.get_open_orders("BTCUSD1", config) ==
                 {:error, {35001, "Contract does not exist"}, 400}
      end)
    end

    test "should return all opens orders of account" do
      config = %ExOkex.Config{
        api_key: "OKEX_API_KEY",
        api_secret: Base.encode64("OKEX_API_SECRET"),
        api_passphrase: "OKEX_API_PASSPHRASE"
      }

      response =
        http_response(
          %{
            "order_info" => [
              %{
                "client_oid" => "",
                "contract_val" => "10",
                "fee" => "-0.000551",
                "filled_qty" => "1",
                "instrument_id" => "EOS-USD-SWAP",
                "order_id" => "6a-7-54d663a28-0",
                "order_type" => "0",
                "price" => "3.633",
                "price_avg" => "3.633",
                "size" => "1",
                "status" => "2",
                "state" => "2",
                "timestamp" => "2019-03-25T05:56:21.674Z",
                "type" => "4"
              },
              %{
                "client_oid" => "",
                "contract_val" => "10",
                "fee" => "-0.000550",
                "filled_qty" => "1",
                "instrument_id" => "EOS-USD-SWAP",
                "order_id" => "6a-8-54cee3a3f-0",
                "order_type" => "0",
                "price" => "3.640",
                "price_avg" => "3.640",
                "size" => "1",
                "status" => "2",
                "state" => "2",
                "timestamp" => "2019-03-25T03:45:17.376Z",
                "type" => "2"
              }
            ]
          },
          200
        )

      with_mock_request(:get, response, fn ->
        assert Api.get_open_orders("BTC-USD-SWAP", config) ==
                 {:ok,
                  %{
                    "order_info" => [
                      %{
                        "client_oid" => "",
                        "contract_val" => "10",
                        "fee" => "-0.000551",
                        "filled_qty" => "1",
                        "instrument_id" => "EOS-USD-SWAP",
                        "order_id" => "6a-7-54d663a28-0",
                        "order_type" => "0",
                        "price" => "3.633",
                        "price_avg" => "3.633",
                        "size" => "1",
                        "state" => "2",
                        "status" => "2",
                        "timestamp" => "2019-03-25T05:56:21.674Z",
                        "type" => "4"
                      },
                      %{
                        "client_oid" => "",
                        "contract_val" => "10",
                        "fee" => "-0.000550",
                        "filled_qty" => "1",
                        "instrument_id" => "EOS-USD-SWAP",
                        "order_id" => "6a-8-54cee3a3f-0",
                        "order_type" => "0",
                        "price" => "3.640",
                        "price_avg" => "3.640",
                        "size" => "1",
                        "state" => "2",
                        "status" => "2",
                        "timestamp" => "2019-03-25T03:45:17.376Z",
                        "type" => "2"
                      }
                    ]
                  }}
      end)
    end
  end
end
