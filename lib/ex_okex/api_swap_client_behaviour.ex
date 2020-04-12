defmodule ExOkex.ApiSwapClientBehaviour do
  @moduledoc false

  @type params :: map
  @type config :: map | nil
  @type response :: ExOkex.Api.response()

  @callback create_order(params, config) :: response
  @callback create_bulk_orders(params, config) :: response
  @callback cancel_orders(String.t(), list, map, config) :: response
  @callback get_position(String.t(), config) :: response
  @callback get_leverage(String.t(), config) :: response
end
