defmodule ExOkex.ApiClientBehaviour do
  @moduledoc false

  @type params :: map
  @type config :: map | nil
  @type response :: ExOkex.Api.response()

  @callback create_order(params, config) :: response
  @callback create_bulk_orders(params, config) :: response
end
