defmodule ExOkex.Ws do
  @moduledoc false

  import Logger, only: [info: 1]
  import Process, only: [send_after: 3]

  # Client API
  defmacro __using__(_opts) do
    quote do
      use WebSockex
      alias ExOkex.Auth
      alias ExOkex.Config
      @base Application.get_env(:ex_okex, :ws_endpoint, "wss://real.okex.com:8443/ws/v3")
      @ping_interval Application.get_env(:ex_okex, :ping_interval, 5_000)

      def start_link(args \\ %{}) do
        name = args[:name] || __MODULE__
        state = Map.merge(args, %{heartbeat: 0})
        WebSockex.start_link(@base, __MODULE__, state, name: name)
      end

      # Callbacks

      def handle_connect(_conn, state) do
        :ok = info("OKEX Connected!")
        send_after(self(), :ws_subscribe, 0)
        {:ok, state}
      end

      def handle_info(
            :ws_subscribe,
            %{channels: channels, require_auth: require_auth} = state
          ) do
        if require_auth == true do
          login(self(), state)
        else
          subscribe(self(), channels)
        end

        send_after(self(), {:heartbeat, :ping}, 20_000)
        {:ok, state}
      end

      def handle_info({:ws_reply, frame}, state) do
        {:reply, frame, state}
      end

      def handle_info({:heartbeat, :ping}, state) do
        send_after(self(), {:heartbeat, :ping}, 4_000)
        {:reply, :ping, state}
      end

      @doc """
      Handles pong response from the okex
      """
      def handle_frame({:binary, <<43, 200, 207, 75, 7, 0>> = pong}, state) do
        pong
        |> :zlib.unzip()
        |> handle_response(state |> inc_heartbeat())
      end

      def handle_frame({:binary, compressed_data}, %{channels: channels} = state) do
        case compressed_data |> :zlib.unzip() |> Jason.decode!() do
          %{"event" => "login", "success" => true} ->
            subscribe(self(), channels)
            {:ok, state}

          response ->
            handle_response(response, state)
        end
      end

      def handle_response("pong", state) do
        {:ok, state}
      end

      def handle_response(resp, state) do
        :ok = info("#{__MODULE__} received response: #{inspect(resp)}")
        {:ok, state}
      end

      def handle_disconnect(resp, state) do
        :ok = info("OKEX Disconnected! #{inspect(resp)}")
        {:ok, state}
      end

      def terminate({:local, :normal}, %{catch_terminate: pid}),
        do: send(pid, :normal_close_terminate)

      def terminate(_, %{catch_terminate: pid}), do: send(pid, :terminate)
      def terminate(_, _), do: :ok

      # Helpers

      defp subscribe(server, channels) do
        params = Jason.encode!(%{op: "subscribe", args: channels})
        send(server, {:ws_reply, {:text, params}})
      end

      defp login(server, %{config: config}) do
        params = Jason.encode!(%{op: "login", args: auth_args(config)})
        send(server, {:ws_reply, {:text, params}})
      end

      defp auth_args(config) do
        %{api_key: api_key, api_secret: api_secret, api_passphrase: api_passphrase} =
          Config.config_or_env_config(config)

        timestamp = Auth.timestamp()
        signed = Auth.sign(timestamp, "GET", "/users/self/verify", %{}, api_secret)

        [api_key, api_passphrase, timestamp, signed]
      end

      defp inc_heartbeat(%{heartbeat: heartbeat} = state) do
        Map.put(state, :heartbeat, heartbeat + 1)
      end

      defoverridable handle_connect: 2, handle_disconnect: 2, handle_response: 2
    end
  end
end
