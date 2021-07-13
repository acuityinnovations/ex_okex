defmodule ExOkex.V5.PublicTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExOkex.V5.Public, as: Api

  describe "get_instruments" do
    test "returns list of intruments" do
      use_cassette "v5/public/get_instruments" do
        assert {:ok,
                %{
                  "code" => "0",
                  "data" => [
                    %{
                      "instId" => _,
                      "instType" => _
                    }
                    | _
                  ]
                }} = Api.get_instruments(%{"instType" => "SPOT"})
      end
    end
  end

  describe "get_ticker" do
    test "returns market data of the ticker" do
      use_cassette "v5/public/get_ticker" do
        assert {:ok,
                %{
                  "code" => "0",
                  "data" => [
                    %{
                      "askPx" => _,
                      "askSz" => _,
                      "bidPx" => _,
                      "bidSz" => _
                    }
                    | _
                  ]
                }} = Api.get_ticker(%{instId: "BTC-USD-SWAP"})
      end
    end
  end

  describe "get_index_price" do
    test "returns market data of the index" do
      use_cassette "v5/public/get_index_price" do
        assert {:ok,
                %{
                  "code" => "0",
                  "data" => [
                    %{
                      "idxPx" => _
                    }
                    | _
                  ]
                }} = Api.get_index_price(%{instId: "BTC-USD"})
      end
    end
  end

  describe "get_mark_price" do
    test "returns market price" do
      use_cassette "v5/public/get_mark_price" do
        assert {:ok,
                %{
                  "code" => "0",
                  "data" => [
                    %{
                      "instId" => _,
                      "instType" => "MARGIN",
                      "markPx" => _
                    }
                    | _
                  ]
                }} = Api.get_mark_price(%{instType: "MARGIN", instId: "BTC-USDT"})
      end
    end
  end

  describe "get_price_limit" do
    test "returns price limits" do
      use_cassette "v5/public/get_price_limit" do
        assert {:ok,
                %{
                  "code" => "0",
                  "data" => [
                    %{
                      "instId" => _,
                      "instType" => "SWAP",
                      "buyLmt" => _,
                      "sellLmt" => _
                    }
                    | _
                  ]
                }} = Api.get_price_limit(%{instId: "BTC-USD-SWAP"})
      end
    end
  end
end
