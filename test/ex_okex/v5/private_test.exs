defmodule ExOkex.V5.PrivateTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExOkex.V5.Private, as: Api

  setup_all do
    System.put_env("OKEX_API_KEY", "fake_api_key")
    System.put_env("OKEX_API_SECRET", "fake_secret_key")
    System.put_env("OKEX_API_PASSPHRASE", "fake_passphrase_key")
    config = %{access_keys: ["OKEX_API_KEY", "OKEX_API_SECRET", "OKEX_API_PASSPHRASE"]}
    HTTPoison.start()
    {:ok, config}
  end

  describe "create_order" do
    test "create an order", config do
      use_cassette "v5/private/create_order" do
        assert {:ok,
                %{
                  "code" => "0",
                  "data" => [
                    %{
                      "clOrdId" => "bb831d77ca9b4aa58b9cab0ce09f4e21",
                      "ordId" => "334893653072175104",
                      "sCode" => "0",
                      "sMsg" => "",
                      "tag" => ""
                    }
                  ],
                  "msg" => ""
                }} =
                 Api.create_order(
                   %{
                     instId: "BTC-USDT",
                     tdMode: "cash",
                     clOrdId: "bb831d77ca9b4aa58b9cab0ce09f4e21",
                     side: "buy",
                     ordType: "limit",
                     sz: "0.0001",
                     px: "32000"
                   },
                   config
                 )
      end
    end
  end

  describe "update_order" do
    test "update an order", config do
      use_cassette "v5/private/update_order" do
        assert {:ok,
                %{
                  "code" => "0",
                  "data" => [
                    %{
                      "clOrdId" => "bb831d77ca9b4aa58b9cab0ce09f4e21",
                      "ordId" => "334891479269269508",
                      "reqId" => "",
                      "sCode" => "0",
                      "sMsg" => ""
                    }
                  ],
                  "msg" => ""
                }} =
                 Api.update_order(
                   %{
                     instId: "BTC-USDT",
                     clOrdId: "bb831d77ca9b4aa58b9cab0ce09f4e21",
                     newSz: "0.0001",
                     newPx: "31000"
                   },
                   config
                 )
      end
    end
  end

  describe "cancel_order" do
    test "cancel an order", config do
      use_cassette "v5/private/cancel_order" do
        assert {:ok,
                %{
                  "code" => "0",
                  "data" => [
                    %{
                      "clOrdId" => "bb831d77ca9b4aa58b9cab0ce09f4e21",
                      "ordId" => "334891479269269508",
                      "sCode" => "0",
                      "sMsg" => ""
                    }
                  ],
                  "msg" => ""
                }} =
                 Api.cancel_order(
                   %{
                     instId: "BTC-USDT",
                     clOrdId: "bb831d77ca9b4aa58b9cab0ce09f4e21"
                   },
                   config
                 )
      end
    end
  end

  describe "get_positions" do
    test "get current leverage", config do
      use_cassette "v5/private/get_positions" do
        assert {:ok,
                %{
                  "code" => "0",
                  "data" => [
                    %{
                      "liab" => "",
                      "optVal" => "",
                      "pos" => "2",
                      "gammaPA" => "",
                      "upl" => "0.5874781407153933",
                      "vegaBS" => "",
                      "mmr" => "2.6638699125628618",
                      "uplRatio" => "0.0176584249816747",
                      "posSide" => "long",
                      "instId" => "BTC-USDT-SWAP",
                      "availPos" => "2",
                      "mgnRatio" => "11.297341170552103",
                      "liqPx" => "31748.517880462077",
                      "adl" => "5",
                      "interest" => "0",
                      "deltaPA" => "",
                      "imr" => "",
                      "lever" => "20",
                      "mgnMode" => "isolated",
                      "liabCcy" => "",
                      "tradeId" => "95547931",
                      "avgPx" => "33269",
                      "uTime" => "1626117052507",
                      "instType" => "SWAP",
                      "posId" => "334869990763552771",
                      "posCcy" => "",
                      "gammaBS" => "",
                      "notionalUsd" => "665.8276249703059",
                      "margin" => "33.269",
                      "vegaPA" => "",
                      "deltaBS" => "",
                      "thetaBS" => "",
                      "ccy" => "USDT",
                      "thetaPA" => "",
                      "cTime" => "1626117052507",
                      "last" => "33300"
                    }
                  ],
                  "msg" => ""
                }} = Api.get_positions(%{instType: "SWAP", instId: "BTC-USDT-SWAP"}, config)
      end
    end
  end

  describe "get_leverage" do
    test "get current leverage", config do
      use_cassette "v5/private/get_leverage" do
        assert {:ok,
                %{
                  "code" => "0",
                  "data" => [
                    %{
                      "instId" => "BTC-USDT-SWAP",
                      "lever" => "10",
                      "mgnMode" => "cross",
                      "posSide" => "long"
                    },
                    %{
                      "instId" => "BTC-USDT-SWAP",
                      "lever" => "10",
                      "mgnMode" => "cross",
                      "posSide" => "short"
                    }
                  ],
                  "msg" => ""
                }} = Api.get_leverage(%{instId: "BTC-USDT-SWAP", mgnMode: "cross"}, config)
      end
    end
  end

  describe "get_open_orders" do
    test "get active orders", config do
      use_cassette "v5/private/get_open_orders" do
        assert {:ok,
                %{
                  "code" => "0",
                  "data" => [
                    %{
                      "accFillSz" => "0",
                      "avgPx" => "",
                      "cTime" => "1626116868915",
                      "category" => "normal",
                      "ccy" => "",
                      "clOrdId" => "bb831d77ca9b4aa58b9cab0ce09f4e21",
                      "fee" => "0",
                      "feeCcy" => "BTC",
                      "fillPx" => "",
                      "fillSz" => "0",
                      "fillTime" => "",
                      "instId" => "BTC-USDT",
                      "instType" => "SPOT",
                      "lever" => "",
                      "ordId" => "334893653072175104",
                      "ordType" => "limit",
                      "pnl" => "0",
                      "posSide" => "net",
                      "px" => "32000",
                      "rebate" => "0",
                      "rebateCcy" => "USDT",
                      "side" => "buy",
                      "slOrdPx" => "",
                      "slTriggerPx" => "",
                      "state" => "live",
                      "sz" => "0.0001",
                      "tag" => "",
                      "tdMode" => "cash",
                      "tpOrdPx" => "",
                      "tpTriggerPx" => "",
                      "tradeId" => "",
                      "uTime" => "1626116868915"
                    }
                  ],
                  "msg" => ""
                }} = Api.get_open_orders(%{instId: "BTC-USDT"}, config)
      end
    end
  end
end
